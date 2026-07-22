#!/bin/bash
# ==============================================================================
# SCRIPT DE PROVISIONAMENTO DE NÓ WORKER / JOINER DO MICROCEPH (TAILSCALE)
# AMBIENTE: STACK NIXOS -> INCUS -> UBUNTU CONTAINER
# ==============================================================================
set -euo pipefail

# Imprime o cabeçalho técnico no estilo do repositório
echo "======================================================================"
echo "🛡️  STARTING MICROCEPH WORKER PROVISIONING PROCESS"
echo "======================================================================"

# 1. Validação de Argumentos de Entrada e Privilégios
if [ "$#" -ne 2 ]; then
    echo "❌ Erro: Argumentos inválidos!"
    echo "👉 Uso: sudo $0 <TOKEN_DO_MICROCEPH> <IP_DO_NO_LIDER>"
    echo "💡 Exemplo: sudo $0 eyJhbGciOi... 100.100.1.15"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "❌ Erro: Este script de infraestrutura requer privilégios de ROOT (sudo)!"
    exit 1
fi

TOKEN_MICROCEPH="$1"
PRIMARY_LEADER_IP="$2"

# 2. Resolução Dinâmica de Interface de Rede (Guarda do Tailscale)
echo "🔍 [1/6] Capturando endereçamento na malha SDN Tailscale..."
LOCAL_TS_IP=$(ip -4 addr show dev tailscale0 2>/dev/null | grep -oP '(?<=inet )\d+(\.\d+){3}' || true)

if [ -z "$LOCAL_TS_IP" ]; then
    echo "❌ Erro Crítico: Interface 'tailscale0' não foi localizada no barramento de rede."
    echo "💡 Certifique-se de que o script 'autoconnect-tailscale.sh' concluiu o handshake."
    exit 1
fi
echo "✅ IP Local Tailscale validado: $LOCAL_TS_IP"

# 3. Teste de Rota e Latência para o Líder do Cluster
echo "⚡ [2/6] Verificando conectividade ICMP contra o painel de controle principal..."
if ! ping -c 2 -W 3 "$PRIMARY_LEADER_IP" >/dev/null 2>&1; then
    echo "❌ Erro: Não há rota até o nó líder ($PRIMARY_LEADER_IP) via túnel Tailscale."
    echo "🔹 Verifique as ACLs do Tailscale ou o status de conexão da máquina principal."
    exit 1
fi
echo "✅ Rota até o cluster líder está ativa e operacional."

# 4. Destruição e Purga de Estados Anteriores (Idempotência)
echo "🧹 [3/6] Executando rotina idempotente de limpeza (Wipe antigo)..."
if snap list microceph >/dev/null 2>&1; then
    echo "⚠️  Instalação prévia do MicroCeph localizada. Purgando daemons e partições..."
    snap remove microceph --purge
    echo "✅ Estado antigo completamente limpo."
else
    echo "🔹 Ambiente limpo. Nenhuma dependência órfã encontrada."
fi

# 5. Instalação e Bloqueio de Ciclo de Vida do Pacote Snap
echo "📦 [4/6] Desdobrando daemons estáveis do MicroCeph..."
snap install microceph --channel=latest/stable
snap refresh --hold microceph
echo "⏳ Aguardando liberação do barramento do sistema de arquivos do snapd..."
snap wait system seed.loaded
echo "✅ MicroCeph instalado com atualizações automáticas desativadas."

# 6. Cluster Join com Forçamento de IP Fixo e Blindagem de Subrede
echo "🤝 [5/6] Executando acoplamento ao barramento do cluster distribuído..."
# Correção técnica: Força o IP correto e injeta 0.0.0.0/0 para pular o validador rígido de subrede /32 do snap
sudo microceph cluster join "$TOKEN_MICROCEPH" \
  --microceph-ip "$LOCAL_TS_IP" \
  --public-network "0.0.0.0/0"

echo "⏳ Aguardando sincronização de chaves criptográficas (keyrings)..."
sleep 5

# 7. Provisionamento de Armazenamento Local Baseado em Arquivo de Loop
echo "💾 [6/6] Inicializando OSD virtual (Loop storage para laboratório)..."
# Adiciona 1 disco simulado de 4GB específico deste novo nó. O Ceph rebalanceará os PGs automaticamente.
sudo microceph disk add loop,4G,1

echo "======================================================================"
echo "🎉 PROVISIONAMENTO CONCLUÍDO COM SUCESSO!"
echo "📌 O nó '$LOCAL_TS_IP' agora é um membro ativo do cluster Ceph."
echo "💡 Verifique a saúde geral rodando 'sudo microceph.ceph osd tree' no líder."
echo "======================================================================"

# #!/bin/bash
      # set -euo pipefail
      #
      # LEADER_IP="100.100.1.15"
      # PORTA_SERVER=8443
      # MEU_HOSTNAME=$(hostname)
      #
      # echo "🔍 Capturando endereçamento de rede local na interface tailscale0..."
      # LOCAL_TS_IP=$(ip -4 addr show dev tailscale0 2>/dev/null | grep -oP '(?<=inet )\d+(\.\d+){3}' || true)
      #
      # if [ -z "$LOCAL_TS_IP" ]; then
      #     echo "❌ Erro Crítico: Interface 'tailscale0' indisponível."
      #     exit 1
      # fi
      #
      # echo "📡 Solicitando token de storage ao líder do cluster ($LEADER_IP)..."
      # TOKEN_RECEBIDO=$(echo "$MEU_HOSTNAME" | nc -w 10 "$LEADER_IP" "$PORTA_SERVER" | xargs || true)
      #
      # if [ -z "$TOKEN_RECEBIDO" ] || [ "$TOKEN_RECEBIDO" == "FAIL" ]; then
      #     echo "❌ Erro ao resgatar o token dinâmico da rede. Abortando join."
      #     exit 1
      # fi
      #
      # echo "🤝 Executando cluster join no MicroCeph..."
      # sudo microceph cluster join "$TOKEN_RECEBIDO" --microceph-ip "$LOCAL_TS_IP" --public-network "0.0.0.0/0"
      #
      # echo "⏳ Aguardando sincronização de daemons..."
      # sleep 5
      #
      # echo "💾 Inicializando OSD virtual baseado em arquivo de Loop..."
      # sudo microceph disk add loop,4G,1
      # echo "✅ MicroCeph Provisionado com sucesso neste nó!"
