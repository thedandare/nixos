#!/usr/bin/env bash
set -euo pipefail

# Configuração de caminhos locais
SCRIPT_FONTE="../net-svc/test_tailscale.sh"
TEMPLATE_YAML="cloud-init.yaml.tmpl.yaml"
OUTPUT_YAML="cloud-init.yaml"

echo "=== 🧬 Compilacao Idempotente do Cloud-Init ==="

# 1. Valida a existência dos arquivos estruturais
if [ ! -f "$SCRIPT_FONTE" ]; then
    echo "Erro Fatal: O arquivo fonte '$SCRIPT_FONTE' nao foi encontrado."
    exit 1
fi

if [ ! -f "$TEMPLATE_YAML" ]; then
    echo "Erro Fatal: O template '$TEMPLATE_YAML' nao foi encontrado."
    exit 1
fi

# 2. Gera o hash Base64 limpo em uma única string (-w 0)
echo "Processando hash Base64 do script de conexao..."
B64_STRING=$(base64 -w 0 "$SCRIPT_FONTE")

# 3. Gera o arquivo final a partir da matriz (Garante idempotência real)
echo "Injetando binario e gerando o arquivo alvo '$OUTPUT_YAML'..."
sed "s|content: INJECT_TAILSCALE_B64_HERE|content: $B64_STRING|g" "$TEMPLATE_YAML" > "$OUTPUT_YAML"

echo "=== Processo Concluido com Sucesso ==="
echo "O arquivo '$OUTPUT_YAML' foi gerado/atualizado e esta pronto."
