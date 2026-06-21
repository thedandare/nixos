#!/bin/sh
# ==============================================================================
# SCRIPT: Runbook Detalhado de Deploy NixOS via Whiptail
# ORG: POSIX Estrito (/bin/sh) - Compatível com NixOS / Ubuntu 26.04
# ==============================================================================

# Define o mapa de cores estilo Hacker
export NEWT_COLORS='
  root=green,black
  window=black,black
  border=green,black
  shadow=grey,black
  title=cyan,black
  textbox=green,black
  button=black,green
  actbutton=black,cyan
  listbox=green,black
  actlistbox=black,green
  label=red,black
'

# Alocação de arquivos temporários para isolamento e auditoria de logs
LOG_PULL="/tmp/rb_pull.$$"
LOG_RSYNC="/tmp/rb_rsync.$$"
LOG_COMMIT="/tmp/rb_commit.$$"
LOG_PUSH="/tmp/rb_push.$$"

# Garante a limpeza dos logs em caso de interrupção ou encerramento
trap 'rm -f "$LOG_PULL" "$LOG_RSYNC" "$LOG_COMMIT" "$LOG_PUSH"' EXIT INT TERM

# Inicialização das variáveis de status textual
ST_PULL="Pendente"
ST_RSYNC="Pendente"
ST_COMMIT="Pendente"
ST_PUSH="Pendente"

# ==============================================================================
# BLOCO 1: EXECUÇÃO DOS COMANDOS COM CAPTURA DE LOGS ESTRETA
# ==============================================================================

# Passo 1: Git Pull
cd /osnix/nixos >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro fatal: Diretorio /osnix/nixos nao encontrado." > "$LOG_PULL"
    ST_PULL="FALHOU 🔴"
else
    git pull > "$LOG_PULL" 2>&1
    if [ $? -eq 0 ]; then ST_PULL="Sucesso 🟢"; else ST_PULL="FALHOU 🔴"; fi
fi

# Passo 2: Rsync (Apenas se o Passo 1 não falhou criticamente no diretório)
if [ "$ST_PULL" != "FALHOU 🔴" ]; then
    cd leonix >/dev/null 2>&1
    if [ $? -eq 0 ] && [ -f "./rsync.sh" ]; then
        ./rsync.sh > "$LOG_RSYNC" 2>&1
        if [ $? -eq 0 ]; then ST_RSYNC="Sucesso 🟢"; else ST_RSYNC="FALHOU 🔴"; fi
        cd ..
    else
        echo "Erro fatal: Diretorio leonix ou ./rsync.sh ausente." > "$LOG_RSYNC"
        ST_RSYNC="FALHOU 🔴"
    fi
else
    echo "Ignorado devido a falha anterior." > "$LOG_RSYNC"
    ST_RSYNC="Cancelado ⚪"
fi

# Passo 3: Git Add & Commit
if [ "$ST_RSYNC" = "Sucesso 🟢" ]; then
    git add . -A > "$LOG_COMMIT" 2>&1
    HOSTNAME_LEONIX=$(uname -n)
    git commit -m "auto commit from $HOSTNAME_LEONIX" >> "$LOG_COMMIT" 2>&1
    if [ $? -eq 0 ]; then ST_COMMIT="Sucesso 🟢"; else ST_COMMIT="FALHOU 🔴"; fi
else
    echo "Ignorado devido a falha anterior." > "$LOG_COMMIT"
    ST_COMMIT="Cancelado ⚪"
fi

# Passo 4: Git Push via pu.sh
if [ "$ST_COMMIT" = "Sucesso 🟢" ] && [ -f "./pu.sh" ]; then
    ./pu.sh > "$LOG_PUSH" 2>&1
    if [ $? -eq 0 ]; then ST_PUSH="Sucesso 🟢"; else ST_PUSH="FALHOU 🔴"; fi
else
    echo "Ignorado devido a falha anterior ou arquivo ./pu.sh ausente." > "$LOG_PUSH"
    ST_PUSH="Cancelado ⚪"
fi

# ==============================================================================
# BLOCO 2: RELATÓRIO INTERATIVO (WHIPTAIL INTERFACE)
# ==============================================================================
TELA=1
while [ "$TELA" -ne 0 ]; do
    # Monta o menu dinamicamente mostrando o status de cada etapa na Tabela
    ESCOLHA=$(whiptail --title "Relatorio do Runbook - NixOS Deploy" \
        --ok-button "Ver Log" \
        --cancel-button "Sair" \
        --menu "Selecione uma etapa para inspecionar os detalhes brutos da saida:\n\n[DICA: Use as setas e confirme com Enter]" \
        18 75 4 \
        "1" "Git Pull: ....................... [$ST_PULL]" \
        "2" "Rsync Sincronizacao: .............. [$ST_RSYNC]" \
        "3" "Git Add/Commit: .................. [$ST_COMMIT]" \
        "4" "Push via pu.sh: .................. [$ST_PUSH]" \
        2>&1 1>/dev/tty </dev/tty)

    if [ $? -ne 0 ]; then
        TELA=0 # Usuário clicou em Sair ou apertou ESC
    else
        # Exibe recursivamente o log associado ao item selecionado
        case "$ESCOLHA" in
            1) whiptail --title "Log Detalhado - Git Pull" --textbox "$LOG_PULL" 18 70 2>&1 1>/dev/tty </dev/tty ;;
            2) whiptail --title "Log Detalhado - Rsync" --textbox "$LOG_RSYNC" 18 70 2>&1 1>/dev/tty </dev/tty ;;
            3) whiptail --title "Log Detalhado - Git Commit" --textbox "$LOG_COMMIT" 18 70 2>&1 1>/dev/tty </dev/tty ;;
            4) whiptail --title "Log Detalhado - Git Push" --textbox "$LOG_PUSH" 18 70 2>&1 1>/dev/tty </dev/tty ;;
        esac
    fi
done

clear
echo "[SUCCESS] Auditoria do Runbook finalizada de forma sanitaria."

# #!/bin/sh
# # ==============================================================================
# # SCRIPT: Runbook Automático de Deploy NixOS via Whiptail
# # ORG: POSIX Estrito (/bin/sh) - Compatível com NixOS / Ubuntu 26.04
# # ==============================================================================
#
# # Define o mapa de cores estilo Hacker
# export NEWT_COLORS='
#   root=green,black
#   window=black,black
#   border=green,black
#   shadow=grey,black
#   title=cyan,black
#   textbox=green,black
#   button=black,green
#   actbutton=black,cyan
#   listbox=green,black
#   actlistbox=black,green
#   label=red,black
# '
#
# # Garante que a TTY seja limpa antes do Whiptail subir
# clear
#
# # Função para exibir janelas de erro críticas de forma explícita
# exibir_erro() {
#     whiptail --title "Erro Critico no Runbook" \
#         --msgbox "Falha detectada na etapa: $1\n\n[O DEPLOY FOI ABORTADO]" 10 60 >/dev/tty
#     exit 1
# }
#
# # Caixa de diálogo inicial confirmando o início do Runbook
# whiptail --title "Runbook NixOS Deployment" \
#     --yesno "Deseja iniciar a sequencia automatica de sincronizacao e commit?" 8 65 >/dev/tty
#
# if [ $? -ne 0 ]; then
#     echo "[INFO] Operacao cancelada pelo usuario."
#     exit 0
# fi
#
# # ==============================================================================
# # MOTOR DE EXECUÇÃO EM BACKGROUND COM BARRA DE PROGRESSO (GAUGE)
# # ==============================================================================
# # Sênior Tip: O whiptail --gauge lê números de 0 a 100 vindos de um pipe.
# # Usamos subshells isolados e verificamos o status ($?) de cada comando do Git/Rsync.
# {
#     echo "0"
#     # Etapa 1: Acessar diretório e atualizar repositório
#     cd /osnix/nixos || exibir_erro "Acessar /osnix/nixos"
#     echo "20"
#
#     git pull >/dev/null 2>&1 || exibir_erro "Git Pull"
#     echo "40"
#
#     # Etapa 2: Executar o rsync local
#     cd leonix && ./rsync.sh || exibir_erro "Executar ./rsync.sh"
#     echo "60"
#
#     # Etapa 3: Preparar e commitar as alterações do NixOS
#     cd ..
#     git add . -A || exibir_erro "Git Add"
#     echo "80"
#
#     # Sênior Tip: uname -n captura o hostname limpo do NixOS (ex: leonix) sem poluir a mensagem
#     HOSTNAME_LEONIX=$(uname -n)
#     git commit -m "auto commit from $HOSTNAME_LEONIX" >/dev/null 2>&1
#
#     # Etapa 4: Push final
#     ./pu.sh >/dev/null 2>&1 || exibir_erro "Executar ./pu.sh (Git Push)"
#     echo "100"
#
# } | whiptail --title "Status do Deploy" --gauge "Sincronizando infraestrutura..." 8 60 0
#
# # Mensagem final de sucesso absoluto
# whiptail --title "Sucesso" --msgbox "Runbook executado com sucesso!\nRepositorio sincronizado e atualizado." 8 50 >/dev/tty
#
# clear
# echo "[SUCCESS] Runbook finalizado de forma sanitaria."
#
#
#
#
# # #!/bin/sh
# # cd /osnix/nixos
# # git pull
# # cd leonix
# # ./rsync.sh
# # cd ..
# # git add . -A
# # git commit -m "auto commit from $(uname -a) "
# # ./pu.sh