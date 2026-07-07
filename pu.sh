#!/bin/sh
echo $1
export GIT_SSH_COMMAND="ssh -i ~/.ssh/tdd_id_ed25519"
if [ -n $1 ]; then
    git add $1 -A
    git commit -m 'auto-commit $(uname -a) em $(date) '

else
    echo [0;31m git add não executado

    git status | grep Untracked
    read -n 1 -p 'Commit?' answer
    case "${answer,,}" in
    s/y)
        git commit -m 'auto-commit $(uname -a) em $(date) '
        ;;
    esac
fi

# git push -u origin main git@github.com:thedandare/ubunix.git
git push --set-upstream git@github.com:thedandare/nixos.git main

<<<<<<< HEAD
# Limpa o diff deixando-o em uma única linha segura para o JSON sem quebrar a estrutura
GIT_CHANGES=$(git diff --cached | head -c 4000 | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/' | tr -d '\n' | tr -d '\r')

# Monta o JSON com o DIFF PURO (sem Base64 para a IA não se confundir)
JSON_PAYLOAD=$(cat <<EOF
{
  "model": "gpt-4o-mini",
  "input": "Escreva uma mensagem de commit curta, concisa, usando o padrão https://www.conventionalcommits.org/en  e em português para este diff do Git. Não use markdown, saudações ou jargões de permissão de arquivo (como 100644). Apenas a mensagem direta. Diff:\\n\\n$GIT_CHANGES",
  "store": false
}
EOF
)

echo $JSON_PAYLOAD
# Faz a requisição HTTP usando curl para o seu endpoint /v1/responses
API_RESPONSE=$(curl -s https://api.openai.com/v1/responses\
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD")

# 1. Extrai o texto cru do JSON com os escapes Unicode nativos (\uXXXX)
RAW_MSG=$(echo "$API_RESPONSE" | tr -d '\n' | tr -d '\r' | awk -F'"text": *"' '{print $2}' | awk -F'"' '{print $1}')

# 2. Converte os caracteres Unicode (\uXXXX) para acentos reais usando o printf nativo
IA_COMMIT_MSG=$(printf '%b' "$(echo "$RAW_MSG" | sed 's/\\u\([0-9a-fA-F]\{4\}\)/\\u\1/g; s/\\n/\n/g; s/\\"/"/g')")

# Se a API falhar por qualquer motivo, usa um fallback seguro compatível com NixOS
if [ -z "$IA_COMMIT_MSG" ] || [ "$IA_COMMIT_MSG" = "null" ]; then
    echo "⚠️  Falha ao obter resposta da LLM. Usando mensagem padrão."
    NIX_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' || hostname -i | awk '{print $1}')
    IA_COMMIT_MSG="auto-commit IP: $NIX_IP em $(date)"
fi

echo "📝 Mensagem gerada: \"$IA_COMMIT_MSG\""

# 5. Executa o Commit e faz o Push
git commit -m "$IA_COMMIT_MSG"
git push -u origin main
=======
>>>>>>> ff8974ed0fc438ec8a67ecbcc487e79bc819f0a7
