#!/bin/sh

# 1. Configurações Iniciais
export GIT_SSH_COMMAND="ssh -i ~/.ssh/tdd_id_ed25519"
OPENAI_API_KEY=$(cat leonix/secret/openai_key 2>/dev/null || cat thumbnix/secret/openai_key 2>/dev/null)

# Garante que o remote origin está correto
git remote set-url origin git@github.com:thedandare/nixos.git 2>/dev/null || git remote add origin git@github.com:thedandare/nixos.git

# 2. Adiciona os arquivos na fila
if [ -n "$1" ]; then
    git add "$1"
else
    echo "\033[0;31mNenhum arquivo passado. Adicionando todas as modificações atuais...\033[0m"
    git add .
fi

# 3. Verifica se realmente há algo para commitar
if git diff --cached --quiet; then
    echo "ℹ️  Nenhuma alteração detectada para commitar."
    exit 0
fi

# 4. Captura as alterações atuais e prepara o prompt para a LLM
echo "🤖 Solicitando mensagem de commit para a IA..."

# Captura o diff bruto
RAW_DIFF=$(git diff --cached | head -c 4000)

# Escapa TODOS os caracteres especiais (aspas, novas linhas, tabs) de forma nativa e indestrutível para o JSON
GIT_CHANGES=$(python3 -c 'import sys, json; print(json.dumps(sys.stdin.read())[1:-1])' <<EOF
$RAW_DIFF
EOF
)

# Monta o JSON para enviar à API da OpenAI (Sintaxe corrigida com vírgula e aspas)
JSON_PAYLOAD=$(cat <<EOF
{
  "model": "gpt-4o-mini",
  "input": "Você é um assistente especialista em Git. Escreva uma mensagem de commit curta, concisa, no imperativo e em português, baseando-se estritamente no código fornecido. Não adicione saudações, explicações ou formatação markdown (como crases). Apenas o texto direto da mensagem. Gere uma mensagem de commit para as seguintes alterações de código:\n\n$GIT_CHANGES",
  "store": false
}
EOF
)

# Faz a requisição HTTP usando curl e extrai o texto gerado de forma compatível
API_RESPONSE=$(curl -s https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD")

# Extrai o conteúdo do campo gerado tratando os escapes textuais do endpoint /responses
IA_COMMIT_MSG=$(echo "$API_RESPONSE" | tr -d '\n' | tr -d '\r' | awk -F'"text": *"' '{print $2}' | awk -F'"' '{print $1}' | sed 's/\\n/\n/g' | sed 's/\\"/"/g')

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
