#!/bin/bash

# ================= CONFIGURAÇÕES DE E-MAIL =================
SMTP_SERVER="100.100.1.15"
SMTP_PORT="25"
EMAIL_TO="root@kub.qzz.io, thedandare@gmail.com"
EMAIL_FROM="$(cat /etc/hostname)@kub.qzz.io"
# ==========================================================

KUBECTL="/snap/bin/microk8s.kubectl"

# Verifica se o nó atual (p8s) está NotReady ou com erro de PLEG
if $KUBECTL get node p8s | grep -q "NotReady" || $KUBECTL describe node p8s | grep -q "PLEG is not healthy"; then
    MSG_LOG="$(date): Erro de PLEG/NotReady detectado no p8s."
    echo "$MSG_LOG" >> /var/log/microk8s-pleg-fix.log

    SUBJECT="ALERTA: MicroK8s no p8s apresentou falha de PLEG"
    BODY="O nó p8s foi detectado como NotReady.\n\nDetalhes consultados no momento:\n$($KUBECTL describe node p8s | grep -A 5 PLEG)\n\nIniciando procedimentos automáticos de reinício dos serviços."

    # Envia o e-mail usando Swaks (evita erro 554 de sincronização)
    swaks --server $SMTP_SERVER --port $SMTP_PORT \
      --to "$EMAIL_TO" \
      --from "$EMAIL_FROM" \
      --header "Subject: $SUBJECT" \
      --body "$BODY" >> /var/log/microk8s-pleg-fix.log 2>&1

    # Executa a correção dos daemons do MicroK8s
    echo "$(date): Reiniciando serviços do MicroK8s..." >> /var/log/microk8s-pleg-fix.log
    systemctl restart snap.microk8s.daemon-containerd
    sleep 5
    systemctl restart snap.microk8s.daemon-kubelet

    echo "$(date): Serviços reiniciados com sucesso." >> /var/log/microk8s-pleg-fix.log
fi
