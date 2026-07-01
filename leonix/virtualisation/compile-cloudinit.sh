#!/usr/bin/env bash
set -euo pipefail


# Configuração de caminhos locais e matrizes
SCRIPT_TAILSCALE="./init_tailscale.sh"
SCRIPT_MICROCEPH="./microceph_cluster_join.sh" # Certifique-se de que este arquivo existe na pasta
TEMPLATE_YAML="cloud-init.template.yaml"
OUTPUT_YAML="cloud-init.yaml"

echo "=== 🧬 Compilacao Declarativa e Criptografica do Cloud-Init ==="

# 1. Valida a existência dos arquivos estruturais e fontes
for FILE in "$SCRIPT_TAILSCALE" "$SCRIPT_MICROCEPH" "$TEMPLATE_YAML"; do
    if [ ! -f "$FILE" ]; then
        echo "❌ Erro Fatal: O componente obrigatório '$FILE' nao foi localizado."
        exit 1
    fi
done

# 2. Resgate de credenciais do ambiente (Esconde chaves do arquivo físico template)
# Substitua ou exporte estas variáveis no seu terminal/shell antes de rodar o script
TS_ID="${TAILSCALE_CLIENT_ID:-''}"
TS_SECRET="${TAILSCALE_CLIENT_SECRET:-''}"

if [ -z "$TS_ID" ] || [ -z "$TS_SECRET" ]; then
    echo "⚠️  Aviso: As variáveis TAILSCALE_CLIENT_ID ou SECRET estao vazias no ambiente do host."
    echo "💡 Certifique-se de exportá-las antes para que a injeção seja concluída."
fi

# 3. Processamento das strings limpas em Base64 (-w 0 impede quebras de linha no YAML)
echo "🔒 Convertendo scripts operacionais para hashes Base64..."
B64_TAILSCALE=$(base64 -w 0 "$SCRIPT_TAILSCALE")
B64_MICROCEPH=$(base64 -w 0 "$SCRIPT_MICROCEPH")

# 4. Geração do arquivo final aplicando a esteira de substituição atômica
echo "🛠️  Injetando segredos e binários no alvo '$OUTPUT_YAML'..."

# O sed usa pipes '|' como delimitadores para evitar colisões com barras em strings criptográficas
sed -e "s|content: INJECT_TAILSCALE_B64_HERE|content: $B64_TAILSCALE|g" \
    -e "s|content: INJECT_MICROCEPH_B64_HERE|content: $B64_MICROCEPH|g" \
    -e "s|TAILSCALE_CLIENT_ID=\"\"|TAILSCALE_CLIENT_ID=\"$TS_ID\"|g" \
    -e "s|TAILSCALE_CLIENT_SECRET=\"\"|TAILSCALE_CLIENT_SECRET=\"$TS_SECRET\"|g" \
    "$TEMPLATE_YAML" > "$OUTPUT_YAML"

echo "=== ✅ Processo de Engenharia Concluido ==="
echo "O manifesto final '$OUTPUT_YAML' foi consolidado com isolamento de credenciais."

# #!/usr/bin/env bash
# set -euo pipefail
#
# # Configuração de caminhos locais
# SCRIPT_FONTE="./init_tailscale.sh"
# TEMPLATE_YAML="cloud-init.template.yaml"
# OUTPUT_YAML="cloud-init.yaml"
#
# echo "=== 🧬 Compilacao Idempotente do Cloud-Init ==="
#
# # 1. Valida a existência dos arquivos estruturais
# if [ ! -f "$SCRIPT_FONTE" ]; then
#     echo "Erro Fatal: O arquivo fonte '$SCRIPT_FONTE' nao foi encontrado."
#     exit 1
# fi
#
# if [ ! -f "$TEMPLATE_YAML" ]; then
#     echo "Erro Fatal: O template '$TEMPLATE_YAML' nao foi encontrado."
#     exit 1
# fi
#
# # 2. Gera o hash Base64 limpo em uma única string (-w 0)
# echo "Processando hash Base64 do script de conexao..."
# B64_STRING=$(base64 -w 0 "$SCRIPT_FONTE")
#
# # 3. Gera o arquivo final a partir da matriz (Garante idempotência real)
# echo "Injetando binario e gerando o arquivo alvo '$OUTPUT_YAML'..."
# sed "s|content: INJECT_TAILSCALE_B64_HERE|content: $B64_STRING|g" "$TEMPLATE_YAML" > "$OUTPUT_YAML"
#
# echo "=== Processo Concluido com Sucesso ==="
# echo "O arquivo '$OUTPUT_YAML' foi gerado/atualizado e esta pronto."
