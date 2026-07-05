#!/bin/sh

# 📐 Define o diretório alvo: Usa o argumento $1 ou o diretório atual (.) se estiver vazio
TARGET_DIR="${1:-.}"

# Se o diretório informado não existir, aborta com erro
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Erro: O diretório '$TARGET_DIR' nao existe."
    exit 1
fi

# Armazena o caminho absoluto de onde o script foi chamado para salvar a imagem no lugar certo
OUTPUT_PATH="$(pwd)/mapa_infra.png"

# Entra temporariamente no diretório alvo para o find gerar caminhos relativos limpos
cd "$TARGET_DIR" || exit 1

# Envelopa toda a lógica de mapeamento dentro de uma função interna
gerar_dados_dot() {
    echo "digraph G {"
    echo '    rankdir=LR;'
    echo '    overlap=false;'
    echo '    splines=true;'
    echo '    nodesep=0.2;'
    echo '    ranksep=1.2;'
    echo '    node [shape=folder, style=filled, fillcolor=lightblue, fontname="Sans", fontsize=10];'
    echo '    "." [label="Root", fillcolor=deepskyblue, shape=box];'

    # Busca subpastas e as 3 extensões pedidas a partir da pasta atual (.)
    find . -mindepth 1 -not -path '*/.*' -not -name '*~' \
        \( -type d -o -name "*.nix" -o -name "*.yaml" -o -name "*.yml" -o -name "*.sh" \) | while IFS= read -r item; do

        parent=$(dirname "$item")
        base=$(basename "$item")

        item_id=$(echo "$item" | sed 's/"/\\"/g')
        parent_id=$(echo "$parent" | sed 's/"/\\"/g')
        base_id=$(echo "$base" | sed 's/"/\\"/g')

        echo "    \"$parent_id\" -> \"$item_id\";"

        # Mantido seu padrão visual de tudo azul como pasta
        echo "    \"$item_id\" [label=\"$base_id\", shape=folder, fillcolor=lightblue];"
    done

    echo "}"
}

# =========================================================================
# 🚀 EXECUÇÃO AUTOMÁTICA EM PIPELINE
# =========================================================================
# Executa a função, compila a imagem no caminho correto e abre no visualizador
gerar_dados_dot | neato -Tpng -o "$OUTPUT_PATH" && mdfried "$OUTPUT_PATH"
