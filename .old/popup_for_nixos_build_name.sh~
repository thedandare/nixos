#!/bin/sh
# precisamos verificar duas coisas antes de agir: se você já está dentro do tmux (para evitar o erro de cliente) e se a sessão já existe.




# 1. Cria um arquivo temporário exclusivo
TEMP_FILE=$(mktemp /tmp/nixos_build.XXXXXX)

# 2. Executa o popup forçando o whiptail a gravar no arquivo absoluto usando "2>"
tmux display-popup -E -w 65 -h 12 "whiptail --inputbox 'Nome:' 10 45 2> '$TEMP_FILE'"

# 3. Lê o nome, monta o label com a data e remove o arquivo temporário
NIXOS_LABEL="$(cat "$TEMP_FILE")-$(date +%d-%m_%H-%M)" && rm -f "$TEMP_FILE"


# Teste para ver o resultado na tela:
echo -e "\033[1;31m $NIXOS_LABEL \033[0m"

# 1. Cria um arquivo temporário para registrar se o usuário cancelou
CONFIRM_FILE=$(mktemp /tmp/nixos_confirm.XXXXXX)

# 2. Dispara o popup do tmux com o menu de confirmação auto-executável
# Dispara o popup do tmux contendo TODO o fluxo (Confirmação -> Temporizador -> Build)
tmux display-popup -E "bash --pretty-print -c '
CONFIRM_FILE=\$(mktemp /tmp/nixos_confirm.XXXXXX)

# 1. Abre o whiptail dentro do popup
whiptail --title \"Iniciando Build em 3s...\" \
        --yes-button \"Instalar Agora\" \
        --no-button \"Cancelar\" \
        --yesno \"Deseja aplicar a configuração?\nLabel: $NIXOS_LABEL\" 10 55 2> \"\$CONFIRM_FILE\" &
W_PID=\$!

# 2. Loop do temporizador de 3 segundos
for i in 2 1 0; do
    sleep 1
    if ! kill -0 \$W_PID 2>/dev/null; then break; fi
done

# 3. Define a resposta (Auto-disparo ou clique do usuário)
if kill -0 \$W_PID 2>/dev/null; then
    kill \$W_PID
    RESULTADO=\"yes\"
else
    wait \$W_PID
    if [ \$? -eq 0 ]; then RESULTADO=\"yes\"; else RESULTADO=\"no\"; fi
fi
rm -f \"\$CONFIRM_FILE\"

# 4. EXECUÇÃO DO BUILD (Agora dentro do popup)
if [ \"\$RESULTADO\" = \"yes\" ]; then
    echo -e \"\033[1;32m🚀 Disparando nixos-rebuild dentro do popup...\033[0m\n\"

    # Executa o rebuild aqui dentro. O popup só fecha quando ele terminar!
    sudo NIXOS_LABEL=\"$NIXOS_LABEL\" nixos-rebuild switch --show-trace

    echo -e \"\n\033[1;32m✅ Build concluído! Pressione ENTER para fechar.\033[0m\"
    read -r
else
    echo -e \"\033[1;31m❌ Instalação cancelada pelo usuário.\033[0m\"
    sleep 1
fi   '"
