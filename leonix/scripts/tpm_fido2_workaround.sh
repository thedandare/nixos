#!/usr/bin/env bash
set -e

echo "=== 1. Limpando instalações antigas ==="
rm -rf /tmp/tpm-fido2-prf

echo "=== 2. Clonando o fork corrigido para FIDO2 ==="
git clone https://github.com/vitorpy/tpm-fido2-prf.git

echo "=== 3. Compilando e Configurando o ambiente via Nix ==="
# O nix-shell garante que o compilador 'go' esteja presente sem quebrar seu sistema
nix-shell -p go --run "
  cd /tmp/tpm-fido2-prf

  echo '-> Compilando o binário tpm-fido...'
  CGO_ENABLED=0 go build -ldflags='-s -w' -o tpm-fido

  echo '-> Criando diretório de binários locais...'
  mkdir -p ~/bin
  cp tpm-fido ~/bin/tpm-fido

  echo '-> Executando instalador de manifestos para o Chrome...'
  chmod +x ./contrib/install.sh
  ./contrib/install.sh
"

echo "========================================================="
echo " COMPILAÇÃO CONCLUÍDA COM SUCESSO!"
echo "========================================================="
echo "Agora faça a ativação visual no seu Chrome:"
echo "1. Abra o Chrome e vá em: chrome://extensions"
echo "2. Ative o 'Modo do desenvolvedor' (Developer mode) no canto superior direito."
echo "3. Clique em 'Carregar expandida' (Load unpacked)."
echo "4. Selecione a pasta: ~/.local/share/tpm-fido-extension/"
echo "========================================================="
echo "Para testar, feche o Chrome completamente e rode no terminal:"
echo " ~/bin/tpm-fido"
echo "========================================================="
