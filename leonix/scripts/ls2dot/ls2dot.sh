#!/bin/sh


# =========================================================================
# 🧭 SELETOR INTERATIVO BUBBLE TEA (Isolamento por Arquivo Temporário)
# =========================================================================
if [ -z "${1:-}" ]; then
    if [ -t 0 ] && [ -f "./seletor.go" ]; then
        echo "💡 Inicializando interface Bubble Tea..."

        # Cria um arquivo temporário para receber o caminho limpo
        TMP_SEL="./leonix_dir.txt"
        rm -f "$TMP_SEL"

        # Executa o Go jogando a interface na tela.
        # O programa vai gravar o resultado direto no arquivo temporário.
        CGO_ENABLED=0 go run seletor.go 2> "$TMP_SEL" </dev/tty >/dev/tty

         # ⏳ GUARDA DE SINCRONIA: Dá 500ms para o processo do Go desalocar a TTY e fechar os arquivos
        sleep 0.5

        # Lê a resposta se o arquivo existir
        if [ -f "$TMP_SEL" ]; then
            CHOSEN_DIR=$(cat "$TMP_SEL")
            echo CHOSEN_DIR $CHOSEN_DIR
            rm -f "$TMP_SEL"
        else
            CHOSEN_DIR=""
        fi
    else
        CHOSEN_DIR=""
    fi

    if [ -z "$CHOSEN_DIR" ]; then
        echo "⚠️  Selecao vazia. Padrao: Diretorio Pai (..)"
        TARGET_DIR=".."
    else
        TARGET_DIR="$CHOSEN_DIR"
    fi
else
    TARGET_DIR="$1"
fi
echo TARGET_DIR $TARGET_DIR

# Se por acaso o alvo resolvido nao for valido, aborta
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Erro: O diretorio '$TARGET_DIR' nao existe."
    exit 1
fi

# Armazena o caminho absoluto de onde o script foi invocado para salvar a imagem lá
OUTPUT_PATH="$(pwd)/mapa_infra.png"
echo OUTPUT_PATH $OUTPUT_PATH
# Entra temporariamente no alvo para que o find gere hashes de caminhos curtos e relativos
# cd "$TARGET_DIR" || exit 1

# Envelopa a geracao do arquivo dot na memoria
gerar_dados_dot() {
    echo "digraph G {"
    echo '    rankdir=LR;'
    echo '    overlap=false;'
    echo '    splines=true;'
    echo '    nodesep=0.2;'
    echo '    ranksep=1.2;'
    echo '    node [shape=folder, style=filled, fillcolor=lightblue, fontname="Sans", fontsize=10];'
    echo '    "." [label="Root", fillcolor=deepskyblue, shape=box];'

    # Busca estritamente subpastas e as 3 extensoes pedidas, tratando os acentos no sed
    find . -mindepth 1 -not -path '*/.*' -not -name '*~' \
        \( -type d -o -name "*.nix" -o -name "*.yaml" -o -name "*.yml" -o -name "*.sh" \) | while IFS= read -r item; do

        parent=$(dirname "$item")
        base=$(basename "$item")

        # Escapa aspas e limpa acentuacao para nao quebrar o stream UTF-8 do mdfried
        item_id=$(echo "$item" | sed 's/\\/\\\\/g; s/"/\\"/g')
        parent_id=$(echo "$parent" | sed 's/\\/\\\\/g; s/"/\\"/g')
        base_id=$(echo "$base" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr 'áàãâéêíóôõúçÁÀÃÂÉÊÍÓÔÕÚÇ' 'aaaaeeioooucaaaaeeiooouc')

        echo "    \"$parent_id\" -> \"$item_id\";"
        echo "    \"$item_id\" [label=\"$base_id\", shape=folder, fillcolor=lightblue];"
    done

    echo "}"
}

# =========================================================================
# 🚀 PIPELINE AUTOMÁTICO DE RENDERIZAÇÃO E ABERTURA
# =========================================================================
 # =========================================================================
# 🚀 PIPELINE AUTOMÁTICO DE RENDERIZAÇÃO E ABERTURA (Fix de Concorrência de Disco)
# =========================================================================
# 1. Executa a geração e aguarda a gravação física terminar no bloco síncrono
gerar_dados_dot | neato -Tpng -o "$OUTPUT_PATH"

# 2. Força o sincronismo do sistema de arquivos (Garante a escrita dos buffers de IO)
sync

# 3. Pequena folga para o Graphviz desalocar o arquivo do sistema
sleep 0.2


# 2. Caminho do arquivo Markdown que o mdfried vai ler
MD_PATH="$(pwd)/README_INFRA.md"

# 3. Gera de forma declarativa o documento Markdown injetando a imagem nova
cat <<EOF > "$MD_PATH"
## Mapeamento de Infraestrutura - Cluster Kubernetes / Incus
---
Este documento foi gerado de forma automatizada pelo pipeline declarativo.
[Mapa de Infraestrutura](file://$OUTPUT_PATH)
---
EOF
tmux source-file /home/leo/.tmux.conf

if [ -n "$TMUX" ]; then tmux   display-popup -E -w 80 -h 20 "timg '$OUTPUT_PATH'; read" \; bind-key -n C-g display-popup -E -w 80 -h 80 'zsh'; else tmux has-session -t main 2>/dev/null && tmux attach-session -t main || (tmux new-session -d -s main "timg '$OUTPUT_PATH'; read" \; bind-key -n C-g display-popup -E -w 80 -h 20 'zsh' \; attach-session -t main); fi

# if [ -n "$TMUX" ]; then tmux split-window -h "timg '$OUTPUT_PATH'; zsh" \; split-window -v "mdfried '$MD_PATH'; zsh" \; bind-key -n C-g display-popup -E -w 80% -h 80% 'zsh'; else tmux has-session -t main 2>/dev/null && tmux attach-session -t main || (tmux new-session -d -s main "timg '$OUTPUT_PATH'; zsh" \; split-window -h "mdfried '$MD_PATH'; zsh" \; bind-key -n C-g display-popup -E -w 80% -h 80% 'zsh' \; attach-session -t main); fi

# 4. Abre o Markdown documentado no mdfried com a imagem integrada de primeira
#  &

