#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. Solicitando Access Token via OAuth ==="
# Ajustado para usar o Content-Type oficial exigido por validadores estritos
API_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${TAILSCALE_CLIENT_ID}" \
  -d "client_secret=${TAILSCALE_CLIENT_SECRET}" \
  "https://api.tailscale.com/api/v2/oauth/token")

API_TOKEN=$(echo "${API_RESPONSE}" | jq -r '.access_token // empty')

if [ -z "${API_TOKEN}" ]; then
    echo "ERRO: Falha ao obter API_TOKEN. Resposta do servidor:"
    echo "${API_RESPONSE}"
    exit 1
fi
echo "Access Token obtido com sucesso."

echo "=== 2. Gerando Auth Key Descartável ==="
# Requisição estruturada com Bearer Token limpo
KEY_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "capabilities": {
      "devices": {
        "create": {
          "reusable": false,
          "ephemeral": true,
          "preauthorized": true,
          "tags": ["tag:teste", "tag:canssh"]
        }
      }
    },
    "expirySeconds": 600
  }' \
  "https://api.tailscale.com/api/v2/tailnet/-/keys")

REQ_KEY=$(echo "${KEY_RESPONSE}" | jq -r '.key // empty')

if [ -z "${REQ_KEY}" ]; then
    echo "ERRO: Falha ao obter REQ_KEY. Resposta do servidor:"
    echo "${KEY_RESPONSE}"
    exit 1
fi
echo "Auth Key descartável gerada: tskey-auth-..."

echo "=== 3. Autenticando na Rede Tailscale ==="
# Executa a junção à malha usando a chave validada
tailscale up --auth-key="${REQ_KEY}" --accept-dns=true --ssh=true --stateful-filtering=false
echo "Nó autenticado com sucesso!"

# 🌐 VERIFICAÇÃO CONDICIONAL DA INTERFACE (Abre console apenas em falha)
# =========================================================================
# Se a interface já existe, passa direto sem tocar no console
if ! ip link show "tailscale0" >/dev/null 2>&1; then

    # Redireciona I/O apenas se a interface falhou (Evita bloqueios precoces)
    exec < /dev/console > /dev/console 2>&1

    echo ""
    echo "======================================================================"
    echo " 🚨 INTERFACE TAILSCALE0 AUSENTE - BLOQUEIO DE SEGURANÇA "
    echo "======================================================================"
    echo "A placa da VPN nao foi criada. Escolha uma acao para continuar:"
    echo ""

    while true; do
    echo "1) Tentar novamente (Forçar checagem atualizada)"
    echo "2) Ignorar (Forçar instalacao do MicroK8s mesmo sem VPN)"
    echo "3) Abortar (Encerrar o script imediatamente)"
    echo ""
    read -p "Selecione a opcao [1-3]: " OPCAO

    case $OPCAO in
        1)
        if ip link show "tailscale0" >/dev/null 2>&1; then
            echo "Sucesso: Interface detectada!"
            break
        else
            echo "Erro: Interface continua ausente."
        fi
        ;;
        2)
        echo "Aviso: Prosseguindo sem a interface ativa."
        break
        ;;
        3)
        echo "Erro Fatal: Boot abortado pelo operador."
        exit 1
        ;;
        *)
        echo "Opcao inválida."
        ;;
    esac
    done
else

    # TOOD ESTAMOS AQUI
    # source ./tailscale_choose_ip.sh
 echo "=== 4. Extraindo e Fixando o IP da Interface Tailscale ==="
    # Sênior/NixOS Tip: O comando ip/jq garante a captura atômica do IPv4 limpo na TTY
    TAILSCALE_IP=$(ip -4 addr show dev tailscale0 | awk '/inet / {print $2}' | cut -d/ -f1)

    if [ -z "${TAILSCALE_IP}" ]; then
        echo "ERRO CRITICO: Nao foi possivel extrair o IP da interface tailscale0."
        exit 1
    fi
    echo "IP extraido com sucesso: ${TAILSCALE_IP}"

    # Injeção dinâmica nas variáveis globais de ambiente do MicroK8s
    # Impede que o plano de controle (Control Plane) tente escutar a eth0
    export MICROK8S_IP="${TAILSCALE_IP}"

    # Executa o seletor de IP em conformidade com o ambiente atual (Ubuntu/NixOS)
    if [ -f "./tailscale_choose_ip.sh" ]; then
        source "./tailscale_choose_ip.sh"
    else
        echo "Aviso: Script tailscale_choose_ip.sh nao localizado. Prosseguindo..."
    fi

fi

sleep 5
tailscale set --webclient=true
tailscale funnel --bg --tcp 80 5252
tailscale funnel --bg --tcp 2409 22