#!/usr/bin/env bash
set -u

echo -e "\033#3 Tradução prática:

Região	País/local	Por que testar
# \033[5m us-east-1 \033[0m\033[7m	EUA/Virginia	melhor default geral, muita capacidade
\033[31m us-east-2	\033[7mEUA/Ohio	 \033[0mbarato, bom fallback
\033[31m us-west-2\033[7m	EUA/Oregon	 \033[0maparece como mais barato no CloudPrice
\033[34m ca-central-1\033[7m	Canadá	 \033[0màs vezes boa latência/custo
\033[33m eu-west-1	\033[7mIrlanda	Europa  \033[0mcom boa capacidade
 \033[33meu-central-1\033[7m	Alemanha	 \033[0mbom hub europeu
\033[35m ap-south-1\033[7m	Índia/Mumbai	 \033[0mHolori aponta como barata em média
\033[35m ap-southeast-1	\033[7mSingapura	 \033[0mbom para comparar Ásia
\033[35m ap-northeast-1	\033[7mJapão/Tóquio	 \033[0mgeralmente mais caro, mas útil para latência global
\033[32m sa-east-1	\033[7mBrasil/São Paulo	 \033[0mbaixa latência no Brasil, mas costuma ser caro
\033[0;"

SAMPLES="${SAMPLES:-5}"

if [ "$#" -gt 0 ]; then
  REGIONS=("$@")
else
  REGIONS=(
    us-east-1
    us-east-2
    us-west-2
    sa-east-1
  )
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "erro: curl nao encontrado"
  exit 1
fi

if ! command -v awk >/dev/null 2>&1; then
  echo "erro: awk nao encontrado"
  exit 1
fi

printf "%-12s %-34s %8s %10s %10s %10s %10s %10s\n" \
  "REGION" "HOST" "HTTP" "DNS_MS" "TCP_MS" "TLS_MS" "TTFB_MS" "TOTAL_MS"

for region in "${REGIONS[@]}"; do
  host="s3.${region}.amazonaws.com"
  url="https://${host}/"

  data=""
  last_error=""

  for ((i = 1; i <= SAMPLES; i++)); do
    out="$(
      curl \
        --silent \
        --show-error \
        --output /dev/null \
        --connect-timeout 5 \
        --max-time 12 \
        --write-out '%{http_code} %{time_namelookup} %{time_connect} %{time_appconnect} %{time_starttransfer} %{time_total}' \
        "$url" 2>&1
    )"

    rc="$?"

    if [ "$rc" -eq 0 ]; then
      data="${data}${out}"$'\n'
    else
      last_error="$out"
    fi
  done

  if [ -z "$data" ]; then
    printf "%-12s %-34s %8s %10s %10s %10s %10s %10s\n" \
      "$region" "$host" "FAIL" "-" "-" "-" "-" "-"
    echo "  erro: ${last_error:-sem detalhes}"
    continue
  fi

  awk -v region="$region" -v host="$host" '
    NF == 6 {
      n++
      http = $1
      dns += $2
      tcp += $3
      tls += $4
      ttfb += $5
      total += $6
    }
    END {
      if (n == 0) {
        printf "%-12s %-34s %8s %10s %10s %10s %10s %10s\n",
          region, host, "FAIL", "-", "-", "-", "-", "-"
      } else {
        printf "%-12s %-34s %8s %10.1f %10.1f %10.1f %10.1f %10.1f\n",
          region,
          host,
          http,
          dns/n*1000,
          tcp/n*1000,
          tls/n*1000,
          ttfb/n*1000,
          total/n*1000
      }
    }
  ' <<< "$data"
done
