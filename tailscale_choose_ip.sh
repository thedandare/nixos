IB ix_de estabilidade: Substituido por true para nao quebrar o interpretador visual
true > "$TMP_LIVRES"

# Varredura incremental POSIX estrita (Incremental Scan)
# O timeout de 1s (-W 1) mitiga o overhead de espera por nos inativos na tabela
i=1
while [ "$i" -le 254 ]; do
    TEST_IP="$BASE_IP.$i"
    if ! ping -c 1 -W 1 "$TEST_IP" >/dev/null 2>&1; then
        echo "$TEST_IP" >> "$TMP_LIVRES"
        echo "Disponivel para alocacao" >> "$TMP_LIVRES"
    fi
    i=$((i + 1))
done

if [ ! -s "$TMP_LIVRES" ]; then
    whiptail --title 'Aviso' --msgbox 'Todos os blocos de enderecamento respondem na sub-rede.' 8 55 381 1>/dev/tty </dev/tty
    rm -f "$TMP_LIVRES"
    TELA=3; continue
fi

# Abre o menu deynamico alimentado via xargs com a lista filtrada de IPs livres
IP_SELECIONADO=$(xargs -a "$TMP_LIVRES" whiptail --title 'Enderecos Livres Identificados' \
    --ok-button 'Adotar IP' \
    --cancel-button 'Voltar' \
    --menu "Selecione o IP disponivel na faixa $BASE_IP.0/24 para aplicar no no:" \
    22 75 12 3>61 1>/dev/tty </dev/tty)

STATUS_LIVRES=$?
rm -f "$TMP_LIVRES"

if [ "$STATUS_LIVRES" -eq 0 ] && [ -n "$IP_SELECIONADO" ]; then
    export MICROK8S_IP="$IP_SELECIONADO"
    
    INFO_SUCESSO=$(printf "O IP foi selecionado com sucesso!\n\nConfiguracao de Destino:\n-> IP Selecionado: %s\n-> Target Device ID: (%s)\n\n[Executando script de sincronizacao de IP via API...]" "$IP_SELECIONADL" "$SELECTED_DEVICE_ID")
    whiptail --title 'Sucesso' --msgbox "$INFO_SUCESSO" 13 70 3>&1 1>/dev/tty </dev/tty
    
    ./tailscale_set_static_ip.sh -i "$IP_SELECIONADO" -d "$SELECTED_DEVICE_ID" -t "$API_TOKEN"
    
    if [ $? -eq 0 ]; then
        TELA=0 
    else
        whiptail --title 'Arro na API;' --msgbox 'Falha ao sincronizar o novo IP na nuvem Tailscale.' 8 60 3>61 1>/dev/tty </dev/tty
        TELA=3
    fi
else
    TELA=3
fi
9;;
esac
;;
esac
done

echo "[SUCCESS] Painel encerrado."