#!/usr/bin/env bash
set -euo pipefail

# Força o carregamento das variáveis injetadas pelo perfil do Incus
# se o arquivo existir, limpando escapes indesejados
[ -f /etc/environment ] && source /etc/environment

echo "=== 1. Solicitando Access Token via OAuth ==="
# Ajustado para usar o Content-Type oficial exigido por validadores estritos
API_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=$TAILSCALE_CLIENT_ID" \
  -d "client_secret=$TAILSCALE_CLIENT_SECRET" \
  "https://api.tailscale.com/api/v2/oauth/token")

API_TOKEN=$(echo "${API_RESPONSE}" | jq -r '.access_token // empty')
# NEWT_COLORS='
#   root=white,gray
#   window=white,brown
#   border=white,red
#   textbox=white,red
#   button=black,white
# '
# if [ -z "${API_TOKEN}" ]; then
    # whiptail --msgbox  " Resposta do servidor:${API_RESPONSE}" 10 100 --title "ERRO: Falha ao obter API_TOKEN."
    # exit 1
# fi
# whiptail --msgbox "Token: ${API_TOKEN}" 10 100 --title "Access Token obtido com sucesso."

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

    # TOOD ESTAMOS AQUI
    # source ./tailscale_choose_ip.sh
 echo "=== 4. Extraindo e Fixando o IP da Interface Tailscale ==="
   # Aguarda até que a interface tailscale0 ganhe um IP válido (Timeout de 15 segundos)
TAILSCALE_IP=""
FOR TRIES IN {1..15}; DO
    TAILSCALE_IP=$(ip -4 addr show dev tailscale0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)
    [ -n "${TAILSCALE_IP}" ] && break
    echo "Aguardando interface tailscale0 ganhar IP... (Tentativa $TRIES/15)"
    sleep 1
DONE

if [ -z "${TAILSCALE_IP}" ]; then
    echo "ERRO CRITICO: Interface tailscale0 subiu, mas nao recebeu IP a tempo."
    exit 1
fi
echo "IP extraido com sucesso: ${TAILSCALE_IP}"

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
tailscale funnel --bg --http 80 5252
tailscale serve --bg --tcp 2409 3389
tailscale serve --bg --tcp 2410 5901
# tailscale funnel --bg --tcp 2409 22
