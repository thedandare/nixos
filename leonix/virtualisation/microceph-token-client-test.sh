# Executado dentro do novo nó/container worker
LEADER_IP="100.100.1.15"
PORTA_SERVER=88
MEU_HOSTNAME=$(hostname)

echo "📡 Solicitando token dinâmico ao servidor de metadados do líder..."

# Envia o hostname próprio via netcat/socat e captura o token puro na resposta
TOKEN_RECEBIDO=$(echo "$MEU_HOSTNAME" | nc -w 5 "$LEADER_IP" "$PORTA_SERVER" | xargs)

if [ -z "$TOKEN_RECEBIDO" ] || [ "$TOKEN_RECEBIDO" == "FAIL" ]; then
    echo "❌ Erro ao resgatar o token dinâmico da rede. Abortando join."
    exit 1
fi

echo "✅ Token resgatado com sucesso via rede SDN!"

# Agora o script prossegue para o comando de join corrigido que criamos antes:
sudo microceph cluster join "$TOKEN_RECEBIDO" --microceph-ip "$LOCAL_TS_IP" --public-network "0.0.0.0/0"
