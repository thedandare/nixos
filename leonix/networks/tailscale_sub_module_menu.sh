#!/bin/sh
# ==============================================================================
# SCRIPT 2: tailscale_sub_module_menu.sh (Retorno via Exit Status)
# ==============================================================================
TMP_MENU="$1"
BASE_PID="$2"

OPCOES=$(cat "/tmp/ts_data.opts.$BASE_PID" 2>/dev/null)
JSON_DATA=$(sudo tailscale status --json)

case "$OPCOES" in *IPV6*) FILTRO_IP=":" ;; *) FILTRO_IP="." ;; esac
JQ_QUERY="[ (.Self | . + {IsSelf: true}), (.Peer[] | . + {IsSelf: false}) ] | .[]"
case "$OPCOES" in *ONLINE_ONLY*) JQ_QUERY="$JQ_QUERY | select(.Online == true)" ;; esac
JQ_FINAL="$JQ_QUERY | {ip: (.TailscaleIPs[] | select(contains(\"$FILTRO_IP\"))), name: .HostName, os: (.OS // \"unknown\"), id: .ID, self: .IsSelf}"

true > "$TMP_MENU"

echo "$JSON_DATA" | jq -r "$JQ_FINAL | \"\(.ip)\n\(.name) (\(.os)) [ID: \(.id | .[0:8])]\(if .self then \" [Sua Maquina]\" else \"\" end)\"" | while read -r linha; do
    if [ -n "$linha" ] && [ "$linha" != "null" ]; then echo "$linha" >> "$TMP_MENU"; fi
done

if [ ! -s "$TMP_MENU" ]; then
    whiptail --title 'Aviso' --msgbox 'Nenhum dispositivo corresponde aos filtros aplicados.' 8 55 3>&1 1>&2 2>&3
    exit 1
fi

# Define a base estável do comando whiptail
CMD="whiptail --title 'Dispositivos Encontrados' --ok-button 'Selecionar' --cancel-button 'Voltar' --menu 'Escolha o no de rede para gerenciar:\n\n[DICA: Use ESC para Voltar]' 22 78 12"

# Monta a string de argumentos escapando cada linha com aspas individuais
ARGS=""
while read -r linha; do
    ARGS="$ARGS \"$linha\""
done < "$TMP_MENU"

# Executa o eval conectando os descritores diretamente na TTY real do terminal
CHOICE=$(eval "$CMD $ARGS" 3>&1 1>&2 2>&3 < /dev/tty)
STATUS_TELA2=$?

if [ "$STATUS_TELA2" -eq 255 ] || [ "$STATUS_TELA2" -eq 1 ]; then
    exit 1  # Retorna para a Tela 1 de forma síncrona
else
    echo "$CHOICE" > "/tmp/ts_data.choice.$BASE_PID"
    SELECTED_DEVICE_ID=$(echo "$JSON_DATA" | jq -r --arg ip "$CHOICE" '[.Self, .Peer[]] | .[] | select(.TailscaleIPs[]? == $ip) | .ID')
    echo "$SELECTED_DEVICE_ID" > "/tmp/ts_data.id.$BASE_PID"
    exit 3  # Força o Orquestrador mestre a avançar para a Tela 3
fi
