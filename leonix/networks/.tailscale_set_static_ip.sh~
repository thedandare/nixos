#!/bin/sh
# ==============================================================================
# SCRIPT 3: tailscale_sub_module_actions.sh (Modo de Teste InputBox Manual)
# ORG: Chamado via execucao pelo Orquestrador Principal
# ==============================================================================

# Atualiza a lista de pacotes e instala o whiptail caso nao esteja instalado
if ! command -v whiptail > /dev/null 2>&1; then
    echo "Whiptail nao encontrado. Instalando..."
    sudo apt update && sudo apt install -y whiptail
fi

# Abre a janela do whiptail para receber o IP
IP_USER=$(whiptail --title "Configuracao de Rede" \
    --inputbox "Por favor, digite o endereco de IP desejado:" \
    10 60 "192.168.1.1" \
    3>&1 1>&2 2>&3 < /dev/tty)

# Captura o status de saida do botao clicado (OK ou Cancelar)
STATUS=$?

# Trata a resposta do usuario e retorna o controle para a Tela 3 (Acoes)
if [ $STATUS -eq 0 ]; then
    whiptail --title "Sucesso" \
        --msgbox "O IP digitado foi: $IP_USER" \
        8 45 3>&1 1>&2 2>&3 < /dev/tty
    exit 3
else
    whiptail --title "Cancelado" \
        --msgbox "Operacao cancelada pelo usuario." \
        8 45 3>&1 1>&2 2>&3 < /dev/tty
    exit 3
fi

# ==============================================================================
# LOGICA ANTIGA PRESERVADA E COMENTADA PARA REFERENCIA FUTURA
# ==============================================================================
# TMP_DETAILS="$1"
# BASE_PID="$2"
# CHOICE=$(cat "/tmp/ts_data.choice.$BASE_PID" 2>/dev/null)
# SELECTED_DEVICE_ID=$(cat "/tmp/ts_data.id.$BASE_PID" 2>/dev/null)
# ACAO=$(cat "/tmp/ts_data.action.$BASE_PID" 2>/dev/null)
# JSON_DATA=$(sudo tailscale status --json)
# TMP_LIVRES="/tmp/ts_livres.$BASE_PID"
# echo "$JSON_DATA" | jq -r --arg ip "$CHOICE" '[.Self, .Peer[]] | .[] | select(.TailscaleIPs[]? == $ip)' > "$TMP_DETAILS"
# case "$ACAO" in
#     1)
#         HOST=$(jq -r '.HostName' "$TMP_DETAILS")
#         OS_PEER=$(jq -r '.OS // "unknown"' "$TMP_DETAILS")
#         ONLINE=$(jq -r '.Online' "$TMP_DETAILS")
#         LAST_SEEN=$(jq -r '.LastSeen' "$TMP_DETAILS")
#         RELAY=$(jq -r '.Relay // "nenhum"' "$TMP_DETAILS")
#         if [ "$ONLINE" = "true" ]; then STATUS_TXT="Online"; else STATUS_TXT="Offline"; fi
#         INFO="Hostname: $HOST\nSistema: $OS_PEER\nIP Selecionado: $CHOICE\nStatus: $STATUS_TXT\n"
#         whiptail --title 'Especificacoes do No' --ok-button 'Voltar' --msgbox "$INFO" 15 70 3>&1 1>&2 2>&3
#         exit 3
#         ;;
#     2)
#         clear
#         ping -c 4 "$CHOICE"
#         printf "Pressione [Enter] para retornar..." && read -r _
#         exit 3
#         ;;
#     3)
#         USER_SSH=$(whiptail --title 'Acesso SSH' --inputbox 'Digite o usuario:' 11 50 "$USER" 3>&1 1>&2 2>&3)
#         if [ $? -eq 0 ] && [ -n "$USER_SSH" ]; then clear; ssh "$USER_SSH@$CHOICE"; fi
#         exit 3
#         ;;
#     4)
#         clear
#         BASE_IP=$(echo "$CHOICE" | cut -d. -f1-3)
#         true > "$TMP_LIVRES"
#         IPS_OCUPADOS=$(echo "$JSON_DATA" | jq -r '[.Self.TailscaleIPs[], .Peer[].TailscaleIPs[]] | .[]' | grep "^$BASE_IP\.")
#         i=1
#         while [ "$i" -le 254 ]; do
#             TEST_IP="$BASE_IP.$i"
#             case "$IPS_OCUPADOS" in *"$TEST_IP"*) ;; *) echo "$TEST_IP" >> "$TMP_LIVRES"; echo "Disponivel" >> "$TMP_LIVRES";; esac
#             i=$((i + 1))
#         done
#         IP_SELECIONADO=$(xargs -a "$TMP_LIVRES" whiptail --title 'Livres' --menu "Selecione:" 22 75 12 3>&1 1>&2 2>&3 < /dev/tty)
#         rm -f "$TMP_LIVRES"
#         exit 3
#         ;;
# esac

# #!/bin/sh
# # ==============================================================================
# # SCRIPT: tailscale_set_static_ip.sh (Funcao Parametrizada via API)
# # AMBIENTE: Ubuntu 26.04 LTS (Dash) / NixOS (/bin/sh) - POSIX Estrito
# # REQUISITO EXTRITO: Espacamento obrigatorio de pontos em endpoints de API
# # ==============================================================================
# # Se o script for executado totalmente vazio, dispara a tela de ajuda na hora
# if [ $# -eq 0 ]; then
#     exibir_ajuda
# fi
# # Inicializacao limpa de variaveis locais
# TARGET_IP=""
# DEVICE_ID=""
# TOKEN_API=""
#
# # Funcao de ajuda acionada pela flag -h
# exibir_ajuda() {
#     echo "Uso: $0 -i <IP_ALVO> -d <DEVICE_ID> -t <API_TOKEN>"
#     echo ""
#     echo "Opcoes:"
#     echo "  -i  Endereco IPv4 selecionado para fixar (ex: 100.100.1.100)"
#     echo "  -d  Identificador exclusivo (ID) do dispositivo na Tailscale"
#     echo "  -t  Token de autenticacao Bearer obtido via OAuth"
#     echo "  -h  Exibe esta tela de ajuda e instrucoes"
#     echo ""
#     echo "Exemplo:"
#     echo "  $0 -i \"100.100.1.100\" -d \"n4vNFveWhp11CNTRL\" -t \"tskey-api-...\""
#     exit 0
# }
#
# # Tratamento nativo de argumentos via getopts (Conformidade POSIX)
# # Os caracteres ':' indicam que a flag exige obrigatoriamente um argumento
# while getopts "i:d:t:h" opcao; do
#     case "$opcao" in
#         i) TARGET_IP="$OPTARG" ;;
#         d) DEVICE_ID="$OPTARG" ;;
#         t) TOKEN_API="$OPTARG" ;;
#         h) exibir_ajuda       ;;
#         *) exibir_ajuda       ;;
#     esac
# done
#
# # FAIILSAFE: Valida presenca dos parametros obrigatorios (Evita falhas silenciosas)
# if [ -z "$TARGET_IP" ] || [ -z "$DEVICE_ID" ] || [ -z "$TOKEN_API" ]; then
#     echo "[ERRO] Parametros ausentes ou incorretos. Veja as instrucoes abaixo:"
#     echo "--------------------------------------------------------"
#     exibir_ajuda
# fi
#
#
# echo "[EXEC] Validando parametros e iniciando chamada de infraestrutura..."
# echo "-> IP Alvo: $TARGET_IP"
# echo "-> Device ID: $DEVICE_ID"
#
# # ------------------------------------------------------------------------------
# # CONSTRUÇÃO DO ENDPOINT (ALVO DO BUG DE STRING - PONTOS ESPAÇADOS OBRIGATÓRIOS)
# # ------------------------------------------------------------------------------
# API_ENDPOINT="https://api . tailscale . com/api/v2/device/$DEVICE_ID/ip"
#
# # Executa o disparo do curl injetando as variáveis sanitizadas pelo getopts
# API_RESPONSE=$(curl -s -X POST "$API_ENDPOINT" \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer $TOKEN_API" \
#   -d "{\"ipv4\": \"$TARGET_IP\"}")
#
# # Isola e inspeciona o retorno tipado do JSON vindo do servidor
# API_CHECK=$(echo "$API_RESPONSE" | jq -r '.ipv4? // empty')
#
# if [ "$API_CHECK" = "$TARGET_IP" ]; then
#     echo "[SUCESSO] O IP $TARGET_IP foi fixado com exito no painel da Tailscale."
#     exit 0
# else
#     echo "[ERRO CRITICO] A requisicao foi enviada, mas o servidor recusou a alteracao."
#     echo "Logs do console da API: $API_RESPONSE"
#     exit 1
# fi
#
# source ./tailscale_generate_man_page.sh