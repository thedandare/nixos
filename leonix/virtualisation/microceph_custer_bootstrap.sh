#!/bin/bash
# ==============================================================================
# SCRIPT DE INICIALIZAÇÃO AUTOMÁTICA DO MICROCEPH PRINCIPAL (TAILSCALE)
# ==============================================================================
set -euo pipefail

# 1. Validação de Argumentos e Permissões
if [ "$#" -ne 1 ]; then
    echo "❌ Erro: Você deve passar o nome do novo nó como argumento!"
    echo "👉 Uso: sudo $0 nome-do-novo-no"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "❌ Erro: Este script precisa ser executado como root (sudo)!"
    exit 1
fi

NOVO_NODE_NAME="$1"

echo "🔍 [1/6] Detectando IP da interface Tailscale..."
# Tenta capturar o IP da interface tailscale0 automaticamente
TAILSCALE_IP=$(ip -4 addr show dev tailscale0 2>/dev/null | grep -oP '(?<=inet )\d+(\.\d+){3}' || true)

if [ -z "$TAILSCALE_IP" ]; then
    echo "❌ Erro: Interface tailscale0 não encontrada ou sem IP configurado."
    echo "💡 Certifique-se de que o Tailscale está ativo e conectado antes de rodar o script."
    exit 1
fi
echo "✅ IP do Tailscale detectado: $TAILSCALE_IP"


echo "🧹 [2/6] Verificando e limpando instalações anteriores do MicroCeph..."
if snap list microceph >/dev/null 2>&1; then
    echo "⚠️ Instalação anterior do MicroCeph detectada. Removendo com --purge..."
    snap remove microceph --purge
    echo "✅ Instalação anterior limpa com sucesso!"
else
    echo "🔹 Nenhuma instalação anterior detectada. Prosseguindo limpo."
fi


echo "📦 [3/6] Instalando o MicroCeph Snap..."
snap install microceph --channel=latest/stable
snap refresh --hold microceph
echo "✅ MicroCeph instalado e atualizações automáticas travadas."


echo "🚀 [4/6] Executando o Bootstrap amarrado ao Tailscale..."
# Usando a flag --public-network 0.0.0.0/0 para blindar o validador de subrede do snap
sudo microceph cluster bootstrap \
  --microceph-ip "$TAILSCALE_IP" \
  --mon-ip "$TAILSCALE_IP" \
  --public-network "0.0.0.0/0"

echo "⏳ Aguardando o daemon do cluster estabilizar..."
sleep 5


echo "💾 [5/6] Criando disco de loop local para o Nó Principal..."
# Cria 1 disco virtual de 4GB local (O erro de PGs sumirá assim que os workers entrarem)
sudo microceph disk add loop,4G,1
echo "✅ Armazenamento local inicializado."


echo "🔑 [6/6] Gerando o Token de Join para o nó worker: '$NOVO_NODE_NAME'..."
echo "----------------------------------------------------------------------"
TOKEN_SAIDA=$(sudo microceph cluster add "$NOVO_NODE_NAME")

echo -e "\n🎉 **CLUSTER MICROCEPH CONFIGURADO COM SUCESSO!** 🎉"
echo "----------------------------------------------------------------------"
echo "📌 IP do Painel de Controle: $TAILSCALE_IP"
echo "📌 Subrede Pública Permitida: Qualquer uma via Tailscale (0.0.0.0/0)"
echo "----------------------------------------------------------------------"
echo "👇 Cole o comando abaixo DIRETAMENTE no terminal do nó '$NOVO_NODE_NAME' (Worker):"
echo ""
echo "$TOKEN_SAIDA"
echo "----------------------------------------------------------------------"
