#!/bin/sh
# ==============================================================================
# SCRIPT: Runbook Definitivo de Deploy - NixOS / Ubuntu 26.04 LTS
# COMPATIBILIDADE: POSIX Estrito (Dash / Sem arrays / Sem subshells órfãos)
# CONFIGURAÇÃO DE INPUT: ESC de 1 clique persistido em runtime
# ==============================================================================

# Zera o delay de timeout da biblioteca newt para registrar o ESC instantaneamente
export ESCDELAY=0

# Define a matriz de cores customizada estilo Hacker
export NEWT_COLORS='
  root=green,black
  window=black,black
  border=green,black
  shadow=grey,black
  title=cyan,black
  textbox=green,black
  button=black,green
  actbutton=black,cyan
  checkbox=green,black
  actcheckbox=black,cyan
  listbox=green,black
  actlistbox=black,green
  label=red,black
'

clear

# ==============================================================================
# FASE 1: VALIDAÇÃO DE DEPENDÊNCIAS IMPERATIVAS
# ==============================================================================
for pacote in whiptail jq iputils-ping tailscale; do
    if ! command -v "$pacote" >/dev/null 2>&1; then
        echo "[EXEC] Componente ausente. Instalando via APT: $pacote"
        sudo apt-get update -y && sudo apt-get install -y whiptail jq iputils-ping tailscale
    fi
done

# Alocação de descritores de logs isolados em memória RAM (/tmp)
LOG_PULL="/tmp/rb_pull.$$"
LOG_RSYNC="/tmp/rb_rsync.$$"
LOG_COMMIT="/tmp/rb_commit.$$"
LOG_PUSH="/tmp/rb_push.$$"
STATUS_TRACKER="/tmp/rb_status.$$"

# Limpeza sanitária dos resíduos de arquivos temporários no encerramento
trap 'rm -f "$LOG_PULL" "$LOG_RSYNC" "$LOG_COMMIT" "$LOG_PUSH" "$STATUS_TRACKER"' EXIT INT TERM

# Inicialização limpa dos buffers de auditoria
echo "PENDENTE" > "$STATUS_TRACKER"

# Janela gráfica de confirmação de barreira inicial
whiptail --title 'Runbook NixOS Deployment' \
    --yesno 'Deseja iniciar a sequencia automatica de sincronizacao e commit?' 8 65 2>&1 1>/dev/tty

if [ $? -ne 0 ]; then
    echo "[INFO] Operacao abortada pelo operador."
    exit 0
fi

# ==============================================================================
# FASE 2: MOTOR SEQUENCIAL EM BACKGROUND COM ALIMENTAÇÃO DO GAUGE
# ==============================================================================
{
    echo "0"

    # --------------------------------------------------------------------------
    # ETAPA 1: Sincronização do Repositório (Git Pull)
    # --------------------------------------------------------------------------
    cd /osnix/nixos >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_PULL" > "$STATUS_TRACKER"
        echo "Erro Fatal: O diretorio local /osnix/nixos nao foi encontrado no sistema." > "$LOG_PULL"
        echo "100"
        exit 1
    fi

    git pull > "$LOG_PULL" 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_PULL" > "$STATUS_TRACKER"
        echo "100"
        exit 1
    fi
    echo "25"

    # --------------------------------------------------------------------------
    # ETAPA 2: Replicação de Arquivos de Infraestrutura (Rsync)
    # --------------------------------------------------------------------------
    cd leonix >/dev/null 2>&1
    if [ $? -ne 0 ] || [ ! -f "./rsync.sh" ]; then
        echo "FALHOU_RSYNC" > "$STATUS_TRACKER"
        echo "Erro Fatal: O subdiretorio 'leonix' ou o script './rsync.sh' estao ausentes." > "$LOG_RSYNC"
        echo "100"
        exit 1
    fi

    ./rsync.sh > "$LOG_RSYNC" 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_RSYNC" > "$STATUS_TRACKER"
        echo "100"
        exit 1
    fi
    cd ..
    echo "50"

    # --------------------------------------------------------------------------
    # ETAPA 3: Consolidação do Estado e Commit (Git Add / Commit)
    # --------------------------------------------------------------------------
    git add . -A > "$LOG_COMMIT" 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_COMMIT" > "$STATUS_TRACKER"
        echo "100"
        exit 1
    fi

    HOSTNAME_NODE=$(uname -n)
    git commit -m "auto commit from $HOSTNAME_NODE" >> "$LOG_COMMIT" 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_COMMIT" > "$STATUS_TRACKER"
        echo "100"
        exit 1
    fi
    echo "75"

    # --------------------------------------------------------------------------
    # ETAPA 4: Publicação das Alterações (Git Push via pu.sh)
    # --------------------------------------------------------------------------
    if [ ! -f "./pu.sh" ]; then
        echo "FALHOU_PUSH" > "$STATUS_TRACKER"
        echo "Erro Fatal: O script de envio './pu.sh' nao foi localizado no diretorio raiz." > "$LOG_PUSH"
        echo "100"
        exit 1
    fi

    ./pu.sh > "$LOG_PUSH" 2>&1
    if [ $? -ne 0 ]; then
        echo "FALHOU_PUSH" > "$STATUS_TRACKER"
        echo "100"
        exit 1
    fi

    # Marcação de conclusão bem-sucedida de todas as barreiras
    echo "SUCESSO" > "$STATUS_TRACKER"
    echo "100"

} | whiptail --title "Status do Deploy" --gauge "Processando automacao de infraestrutura..." 8 65 0

# Lê o veredito final capturado do motor em background
RESULTADO=$(cat "$STATUS_TRACKER")

# ==============================================================================
# FASE 3: RELATÓRIO DINÂMICO DE AUDITORIA (TRATAMENTO DE ERROS SEM FALLBACK)
# ==============================================================================
if [ "$RESULTADO" = "SUCESSO" ]; then
    whiptail --title 'Sucesso Absoluto' \
        --msgbox 'Runbook executado com 100% de exito!\n\nRepositorio atualizado, sincronizado e publicado.' 10 60 2>&1 1>/dev/tty
else
    # Mapeia qual etapa causou a falha do sistema para direcionar o operador
    case "$RESULTADO" in
        FALHOU_PULL)   ETAPA="Git Pull";    ALVO_LOG="$LOG_PULL" ;;
        FALHOU_RSYNC)  ETAPA="./rsync.sh";  ALVO_LOG="$LOG_RSYNC" ;;
        FALHOU_COMMIT) ETAPA="Git Commit";  ALVO_LOG="$LOG_COMMIT" ;;
        FALHOU_PUSH)   ETAPA="./pu.sh";     ALVO_LOG="$LOG_PUSH" ;;
        *)             ETAPA="Desconhecida";ALVO_LOG="/dev/null" ;;
    esac

    whiptail --title 'Erro Detectado no Runbook' \
        --msgbox "O deploy falhou na etapa: [$ETAPA]\n\nA seguir, inspecione o log real do console gerado pelo comando." 10 65 2>&1 1>/dev/tty

    # Exibe o visualizador de texto nativo com rolagem para depuração do erro em tela
    whiptail --title "Log de Console - Falha em $ETAPA" --textbox "$ALVO_LOG" 18 78 2>&1 1>/dev/tty
fi

clear
echo "[SUCCESS] Rotina de execucao e auditoria do Runbook finalizada."
