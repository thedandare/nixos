#!/bin/sh
SESSION_NAME="main"

# 1. Verifica se a sessão já existe
tmux has-session -t "$SESSION_NAME" 2>/dev/null
SESSION_EXISTS=$?

echo -e " \033[7;40m Cria a sessão em segundo plano se ela não existir \033[0m"
if [ $SESSION_EXISTS -ne 0 ]; then
    tmux new-session -d -s "$SESSION_NAME"
     # whiptail --msgbox "Bem-vindo a nova sessão" --ok-button "🫵" 8 54
fi



echo -e " \033[7;40m   Conectando de forma inteligente dependendo de onde o script é rodado"
if [ -n "$TMUX" ]; then
    echo -e " \033[7;40m  JÁ ESTÁ dentro do tmux, alterna para a sessão sem precisar de cliente externo"
    tmux switch-client -t "$SESSION_NAME"
        tmux  display-popup -E -w 65 -h 12  "whiptail --msgbox \"Sessão recuperada [switch-client]\" --ok-button \"🫵\" 8 54"

else
    echo -e " \033[7;40m  ESTÁ FORA do tmux, força a conexão criando um cliente no terminal atual"
    tmux attach-session -t "$SESSION_NAME"
    sleep 2
   # whiptail --msgbox \"Sessão recuperada [attach-session]\" --ok-button \"🫵\" 8 54
fi
