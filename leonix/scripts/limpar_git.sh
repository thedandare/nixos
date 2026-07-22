#!/bin/sh

# Interrompe o script se qualquer comando falhar
set -e

echo "========================================================="
echo "   SCRIPT DE REINICIALIZAÇÃO LIMPA DO REPOSITÓRIO GIT"
echo "========================================================="
echo "⚠️  ATENÇÃO: Isso vai apagar TODO o histórico de commits!"
echo "Os arquivos atuais da pasta serão mantidos, mas o histórico sumirá."
echo "---------------------------------------------------------"

# Confirmação inicial
printf "Tem certeza que deseja continuar? (s/N): "
read -r resposta
if [ "$resposta" != "s" ] && [ "$resposta" != "S" ]; then
    echo "❌ Operação cancelada pelo usuário."
    exit 0
fi

# Solicita a URL do GitHub
printf "Insira a URL do seu repositório GitHub (ex: https://github.com...): "
read -r git_url
if [ -z "$git_url" ]; then
    echo "❌ URL inválida. O script foi abortado."
    exit 1
fi

echo "\n🔄 1. Apagando histórico antigo do Git (.git)..."
rm -rf .git

echo "🆕 2. Inicializando novo repositório Git com a branch 'main'..."
git init -b main

# Verifica se o .gitignore existe antes de prosseguir
if [ ! -f .gitignore ]; then
    echo "⚠️  AVISO: .gitignore não encontrado na raiz!"
    printf "Deseja criar um .gitignore básico agora para ignorar 'secret/' e '.old/'? (s/N): "
    read -r criar_ignore
    if [ "$criar_ignore" = "s" ] || [ "$criar_ignore" = "S" ]; then
        echo "**/secret/" >> .gitignore
        echo "**/.old/" >> .gitignore
        echo "result" >> .gitignore
        echo ".direnv" >> .gitignore
        echo "✅ .gitignore criado com sucesso."
    fi
fi

echo "📦 3. Adicionando arquivos atuais (respeitando o .gitignore)..."
git add .

echo "💾 4. Criando o commit inicial limpo..."
git commit -m "Initial commit (clean)"

echo "🔗 5. Vinculando ao repositório remoto do GitHub..."
git remote add origin "$git_url"

echo "---------------------------------------------------------"
echo "🚀 PRONTO PARA O ENVIO FORÇADO!"
echo "Isso vai esmagar definitivamente o histórico atual no GitHub."
echo "---------------------------------------------------------"
printf "Deseja rodar o 'git push --force' agora? (s/N): "
read -r enviar_push

if [ "$enviar_push" = "s" ] || [ "$enviar_push" = "S" ]; then
    echo "📤 Enviando para o GitHub..."
    git push -u origin main --force
    echo "\n✨ Sucesso! Seu repositório no GitHub está zerado e limpo."
else
    echo "\n✅ Histórico reiniciado localmente com sucesso!"
    echo "Quando estiver pronto, envie manualmente usando: git push -u origin main --force"
fi
