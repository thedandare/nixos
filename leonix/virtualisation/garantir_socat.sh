#!/bin/sh

# 1. Verifica se o usuário passou a porta como argumento
if [ -z "$1" ]; then
    echo "Erro: Você precisa informar a porta de escuta."
    echo "Uso: $0 <porta>"
    exit 1
fi

PORTA="$1"

# 2. Garante que o socat está instalado (comum no Alpine)
if ! command -v socat >/dev/null 2>&1; then
    echo "Instalando o socat..."
    apk add socat >/dev/null
fi

# 3. Define a linha exata que deve estar no crontab
# Nota: No crontab do Alpine (busybox), o caractere '%' precisa ser escapado com '\' se usado, 
# mas nossa lógica com awk usa \$7 de forma segura para shell.
LINHA_CRON="*/5 * * * * pgrep -f \"TCP-LISTEN:$PORTA\" >/dev/null || /usr/bin/socat -d -d TCP-LISTEN:$PORTA,fork TCP:\$(ip route get 1 | awk '{print \$7}'):5678 >/dev/null 2>&1"

# 4. Verifica se a regra para esta porta específica já existe no crontab
if crontab -l 2>/dev/null | grep -F "TCP-LISTEN:$PORTA" >/dev/null; then
    echo "Aviso: Já existe uma regra de monitoramento para a porta $PORTA no crontab."
else
    # 5. Adiciona a nova linha de forma segura sem duplicar o resto
    (crontab -l 2>/dev/null; echo "$LINHA_CRON") | crontab -
    echo "Sucesso: Regra para a porta $PORTA adicionada ao crontab!"
fi
