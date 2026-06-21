#!/bin/sh
# ==============================================================================
# SCRIPT: Runbook Automático de Deploy NixOS via Whiptail
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

# Garante que a TTY seja limpa antes do Whiptail subir
clear

# Função para exibir janelas de erro críticas de forma explícita
exibir_erro() {
    whiptail --title "Erro Critico no Runbook" \
        --msgbox "Falha detectada na etapa: $1\n\n[O DEPLOY FOI ABORTADO]" 10 60 >/dev/tty
    exit 1
}

# Caixa de diálogo inicial confirmando o início do Runbook
whiptail --title "Runbook NixOS Deployment" \
    --yesno "Deseja iniciar a sequencia automatica de sincronizacao e commit?" 8 65 >/dev/tty

if [ $? -ne 0 ]; then
    echo "[INFO] Operacao cancelada pelo usuario."
    exit 0
fi

# ==============================================================================
# MOTOR DE EXECUÇÃO EM BACKGROUND COM BARRA DE PROGRESSO (GAUGE)
# ==============================================================================
# Sênior Tip: O whiptail --gauge lê números de 0 a 100 vindos de um pipe.
# Usamos subshells isolados e verificamos o status ($?) de cada comando do Git/Rsync.
{
    echo "0"
    # Etapa 1: Acessar diretório e atualizar repositório
    cd /osnix/nixos || exibir_erro "Acessar /osnix/nixos"
    echo "20"

    git pull >/dev/null 2>&1 || exibir_erro "Git Pull"
    echo "40"

    # Etapa 2: Executar o rsync local
    cd leonix && ./rsync.sh || exibir_erro "Executar ./rsync.sh"
    echo "60"

    # Etapa 3: Preparar e commitar as alterações do NixOS
    cd ..
    git add . -A || exibir_erro "Git Add"
    echo "80"

    # Sênior Tip: uname -n captura o hostname limpo do NixOS (ex: leonix) sem poluir a mensagem
    HOSTNAME_LEONIX=$(uname -n)
    git commit -m "auto commit from $HOSTNAME_LEONIX" >/dev/null 2>&1

    # Etapa 4: Push final
    ./pu.sh >/dev/null 2>&1 || exibir_erro "Executar ./pu.sh (Git Push)"
    echo "100"

} | whiptail --title "Status do Deploy" --gauge "Sincronizando infraestrutura..." 8 60 0

# Mensagem final de sucesso absoluto
whiptail --title "Sucesso" --msgbox "Runbook executado com sucesso!\nRepositorio sincronizado e atualizado." 8 50 >/dev/tty

clear
echo "[SUCCESS] Runbook finalizado de forma sanitaria."




# #!/bin/sh
# cd /osnix/nixos
# git pull
# cd leonix
# ./rsync.sh
# cd ..
# git add . -A
# git commit -m "auto commit from $(uname -a) "
# ./pu.sh