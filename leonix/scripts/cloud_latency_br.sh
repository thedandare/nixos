#!/bin/sh

# Cores para facilitar a leitura
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}   TESTE DE LATÊNCIA - NUVENS BRASIL (CENTRO-SUL)     ${NC}"
echo -e "${CYAN}======================================================${NC}"
echo "Data: $(date)"
echo "Nota: Testando com variação de tamanho de pacote (Payload)."
echo ""

# Lista de Provedores e seus Endpoints Regionais (SP/RJ)
# Usamos endpoints de serviço (Object Storage/API) que ficam fixos na região.
declare -A clouds
clouds["AWS (São Paulo)"]="dynamodb.sa-east-1.amazonaws.com"
clouds["Azure (Brasil Sul)"]="brazilsouth.blob.core.windows.net"
clouds["Google (Osasco)"]="://googleapis.com" # GCP usa Anycast, mas direciona ao PoP local
clouds["Oracle (Vinhedo)"]="objectstorage.sa-vinhedo-1.oraclecloud.com"
clouds["Huawei (São Paulo)"]="obs.sa-brazil-1.myhuaweicloud.com"
clouds["IBM Cloud (São Paulo)"]="s3.br-sao.cloud-object-storage.appdomain.cloud"

# Tamanhos dos pacotes para simular cargas diferentes (em bytes)
# 64: Ping padrão
# 512: Pacote médio
# 1024: Pacote maior (simula tráfego de dados mais pesado)
packet_sizes=(64 512 1024)

# Loop pelos provedores
for provider in "${!clouds[@]}"; do
    host=${clouds[$provider]}

    echo -e "${GREEN}Target: $provider${NC}"
    echo -e "Endpoint: $host"

    # Resolve o IP para mostrar ao usuário (informativo)
    target_ip=$(dig +short $host | head -n 1)
    if [ -z "$target_ip" ]; then
        echo "   -> IP: Não resolvido (DNS falhou)"
    else
        echo "   -> IP Resolvido: $target_ip"
    fi

    echo -e "   -------------------------------------------------"
    printf "   %-10s | %-10s | %-10s | %-10s\n" "Tam(Bytes)" "Min(ms)" "Avg(ms)" "Max(ms)"
    echo -e "   -------------------------------------------------"

    for size in "${packet_sizes[@]}"; do
        # Executa o ping (4 envios, timeout de 1s por pacote)
        # O grep/awk extrai apenas os números do resumo final rtt min/avg/max/mdev
        result=$(ping -c 4 -s $size -W 1 $host 2>/dev/null | tail -1 | awk -F '/' '{print $4 " / " $5 " / " $6}')

        if [ -z "$result" ]; then
            printf "   %-10s | %-20s\n" "$size" "${RED}Bloqueado/Timeout${NC}"
        else
            # Formata a saída separando os valores
            min=$(echo $result | awk '{print $1}')
            avg=$(echo $result | awk '{print $3}')
            max=$(echo $result | awk '{print $5}')
            printf "   %-10s | %-10s | %-10s | %-10s\n" "$size" "$min" "$avg" "$max"
        fi
    done
    echo ""
done

echo -e "${CYAN}Teste finalizado.${NC}"
