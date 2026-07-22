# 1. Defina as variáveis de teste no terminal
SMTP_SERVER="100.100.1.15"
SMTP_PORT="25"
EMAIL_TO="root@kub.qzz.io, thedandare@gmail.com"
EMAIL_FROM="$(cat /etc/hostname)@kub.qzz.io"

# # 2. Execute o envio manual via Netcat (nc)
# (
#   echo "HELO $(cat /etc/hostname).local"
#   sleep 1
#   echo "MAIL FROM: <$EMAIL_FROM>"
#   sleep 1
#   for email in $(echo "$EMAIL_TO" | tr ',' ' '); do
#       echo "RCPT TO: <$email>"
#       sleep 1
#   done
#   echo "DATA"
#   sleep 1
#   echo "Subject: [TESTE] Envio manual do p8s para o kub"
#   echo "To: $EMAIL_TO"
#   echo "From: $EMAIL_FROM"
#   echo "Content-Type: text/plain; charset=UTF-8"
#   echo ""
#   echo "Este e um e-mail de teste manual para validar a comunicacao do script de monitoramento."
#   echo "."
#   sleep 1
#   echo "QUIT"
# ) | nc -w 10 $SMTP_SERVER $SMTP_PORT

swaks --server 100.100.1.15 --port 25 \
  --to "root@kub.qzz.io, thedandare@gmail.com" \
  --from "$(cat /etc/hostname)@kub.qzz.io" \
  --header "Subject: [TESTE] Envio corrigido do p8s para o kub" \
  --body "Este é um e-mail de teste usando Swaks para evitar o erro de sincronização SMTP."

