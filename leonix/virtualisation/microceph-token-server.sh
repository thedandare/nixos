#!/bin/bash
# ==============================================================================
# SERVIDOR DE METADADOS ULTRALEVE PARA GERAÇÃO DINÂMICA DE TOKENS MICROCEPH
# ARQUITETURA: Executa no Nó Líder (nk8s) escutando via Socat na rede Tailscale
# ==============================================================================
set -euo pipefail

PORTA=88

# Garante que o socat está instalado no líder
if ! command -v socat &> /dev/null; then
    echo "📦 Instalando dependência 'socat' no líder..."
    sudo apt-get update && sudo apt-get install -y socat
fi

# Função interna que trata cada requisição recebida da rede
processar_requisicao() {
    # Lê a primeira linha enviada pelo cliente (espera o hostname do nó worker)
    read -r WORKER_HOSTNAME

    # Remove caracteres especiais ou quebras de linha invisíveis para higienizar o input
    WORKER_HOSTNAME=$(echo "$WORKER_HOSTNAME" | tr -cd 'a-zA-Z0-9_-')

    if [ -z "$WORKER_HOSTNAME" ]; then
        echo "❌ ERRO: Hostname inválido ou vazio recebido."
        return
    fi

    # Registra o log no terminal do servidor
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] 🔑 Gerando token para o nó worker: '$WORKER_HOSTNAME'" >&2

    # Executa o comando oficial do MicroCeph para gerar o token de adesão
    # Captura apenas a string do token limpando saídas visuais
    TOKEN=$(sudo microceph cluster add "$WORKER_HOSTNAME" 2>/dev/null | grep -v "microceph cluster join" | xargs)

    if [ -n "$TOKEN" ]; then
        # Envia o token puro de volta pelo socket do socat para o cliente
        echo "$TOKEN"
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✅ Token enviado com sucesso." >&2
    else
        echo "❌ ERRO: Falha ao gerar o token no subsistema MicroCeph."
        echo "FAIL"
    fi
}

# Exporta a função para que o subshell do socat consiga enxergá-la
export -f processar_requisicao

echo "======================================================================"
echo "🚀 Servidor de Tokens MicroCeph Ativo e Escutando na Porta: $PORTA"
echo "🌐 Interface: escutando requisições da malha Tailscale"
echo "======================================================================"

# O comando Socat fica em loop infinito (fork) aguardando novas conexões tcp
# Ele joga a entrada da rede na nossa função Bash 'processar_requisicao'
socat TCP-LISTEN:"$PORTA",reuseaddr,fork SYSTEM:"bash -c processar_requisicao"



sudo cat << 'EOF' > /etc/systemd/system/microceph-token-server.service
[Unit]
Description=Servidor de Metadados Ultraleve para Tokens MicroCeph
After=network.target tailscaled.service
Wants=tailscaled.service

[Service]
Type=simple
ExecStart=/usr/local/bin/microceph-token-server.sh
# 🛡️ BLINDAGEM: Se o script falhar ou o processo morrer, o sistema força o reboot dele em 5 segundos
Restart=always
RestartSec=5s
User=root
WorkingDirectory=/usr/local/bin

[Install]
WantedBy=multi-user.target
EOF
