#!/bin/sh
# services.outline.secretKeyFile => It must be 32 bytes long and hex-encoded.
# A 32-byte, hex-encoded string is a 64-character string composed of the numbers 0-9 and the letters a-f.
# Since 1 byte equals 2 hex characters, 32 × 2 = 64 characters.
# For security purposes, you should always generate your own unique secret keys in a secure environment.
# Providing a pre-generated key is not a safe practice for production applications.
# You can use the following language-specific commands to generate a new, cryptographically
# secure 32-byte hex key for your local environment:

# Node.js: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# Python: python3 -c "import secrets; print(secrets.token_hex(32))"
# Linux/macOS terminal: openssl rand -hex 32

# Para transformar um segredo existente em uma chave de 32 bytes (64 caracteres hexadecimais),
# você deve usar uma função de hash criptográfica como o SHA-256 ou uma função de derivação de
# chave (KDF). O processo garante que qualquer texto de entrada gere um resultado único e com
# o tamanho exato exigido.Comandos para gerar a chaveEscolha a ferramenta de sua preferência para
# processar o seu segredo atual:
# Python: python3 -c "import hashlib; print(hashlib.sha256(b'SEU_SEGREDO_AQUI').hexdigest())"
# Node.js: node -e "console.log(require('crypto').createHash('sha256').update('SEU_SEGREDO_AQUI').digest('hex'))"

# terminal:
 echo -n "0utl1ne" | openssl dgst -sha256 -r | awk '{print $1}' > ../secret/outline_key

 # -r: Muda a saída para o formato "reverso", colocando a chave primeiro e o nome do arquivo depois
 # awk '{print $1}': Filtra o resultado para pegar apenas a primeira palavra da linha, isolando a chave antes de salvá-la.


# Cuidados importantesEvite o comando echo simples:
# O comando echo comum adiciona uma quebra de linha (\n) oculta no fim do texto.
# Use sempre echo -n no terminal para evitar que essa quebra altere o resultado do hash.
