#!/bin/sh

# Garante que o dialog está instalado
if ! command -v dialog &> /dev/null; then
    echo "O utilitário 'dialog' não está instalado."
    echo "Instale com: sudo apt install dialog (Debian/Ubuntu) ou sudo dnf install dialog (RHEL/CentOS)"
    exit 1
fi

# Captura o IP do Alvo
ALVO=$(dialog --title "Fail2Ban Teste Interativo" \
              --inputbox "Digite o IP do servidor alvo (com Fail2ban):" 8 50 \
              "192.168.1.50" 3>&1 1>&2 2>&3)

# Se o usuário cancelar, encerra o script
[ -z "$ALVO" ] && exit 0

# Captura a Porta SSH
PORTA=$(dialog --title "Fail2Ban Teste Interativo" \
               --inputbox "Digite a porta SSH do servidor:" 8 50 \
               "22" 3>&1 1>&2 2>&3)

[ -z "$PORTA" ] && exit 0

# Captura a quantidade de tentativas
TENTATIVAS=$(dialog --title "Fail2Ban Teste Interativo" \
                    --inputbox "Quantas tentativas de login malsucedidas deseja simular?\n(Deve ser MAIOR que o 'maxretry' do servidor)" 9 60 \
                    "5" 3>&1 1>&2 2>&3)

[ -z "$TENTATIVAS" ] && exit 0

# Confirmação final antes de rodar
dialog --title "Confirmar Ataque Simulado" \
       --yesno "Deseja iniciar as $TENTATIVAS tentativas contra $ALVO:$PORTA?" 7 60

if [ $? -eq 0 ]; then
    clear
    echo "======================================================"
    echo "Iniciando força bruta simulada contra $ALVO..."
    echo "======================================================"
    
    for i in $(seq 1 "$TENTATIVAS"); do
        echo "Enviando requisição incorreta $i de $TENTATIVAS..."
        # Força falha de senha de forma rápida sem interação humana
        ssh -p "$PORTA" -o ConnectTimeout=2 -o PasswordAuthentication=yes -o PubkeyAuthentication=no usuario_teste@"$ALVO" "exit" 2>/dev/null
    done

    echo -e "\n[✔] Processo concluído!"
    echo "Vá até o servidor e digite: sudo fail2ban-client status sshd"
else
    clear
    echo "Teste cancelado pelo usuário."
fi

