#!/usr/bin/env bash

SECRET_FILE="/etc/nixos/secret/default.nix"
SENHA="$1"

# Valida se a senha foi enviada no argumento
if [ -z "$SENHA" ]; then
    echo "Erro: Forneça a senha do Pi-hole."
    echo "Uso: sudo $0 'minha_senha_secreta'"
    exit 1
fi

# 1. Gera a hash oficial do Pi-hole v6
echo "Gerando hash da senha..."
HASH=$(pihole-FTL-pwhash "$SENHA")

if [ -z "$HASH" ]; then
    echo "Erro ao gerar a hash. Verifique se o pihole-ftl está no PATH."
    exit 1
fi

# 2. Insere ou substitui o bloco pihole dentro do arquivo de segredos
if grep -q "pihole =" "$SECRET_FILE"; then
    echo "Atualizando hash existente no arquivo de segredos..."
    # Atualiza a hash caso a chave "pihole" já exista no arquivo
    sed -i -E "s#(pwhash\s*=\s*\")[^\"]*(\";)#\1$HASH\2#" "$SECRET_FILE"
else
    echo "Injetando novo bloco pihole no arquivo de segredos..."
    # Insere o bloco pihole exatamente antes da última chave de fechamento '}' do arquivo
    # Preserva a indentação de 2 espaços
    sed -i "$ s#^}\$#  pihole = {\n    pwhash = \"$HASH\";\n  };\n}#" "$SECRET_FILE"
fi

# 3. Executa o rebuild do NixOS
echo "Reconstruindo o sistema NixOS..."
nixos-rebuild switch
