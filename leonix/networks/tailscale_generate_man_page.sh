#!/bin/sh
# Cria o arquivo de manual de forma automatizada usando Here-Doc POSIX
cat << 'EOF' > tailscale_set_static_ip.1
.TH TAILSCALE_SET_STATIC_IP 1 "Junho 2026" "Versao 1.0" "Manuais do Usuario"
.SH NOME
tailscale_set_static_ip \- Fixa um endereco IP estatico na API v2 da Tailscale
.SH SINOPSE
.B tailscale_set_static_ip
[\-i \fIIP_ALVO\fR] [\-d \fIDEVICE_ID\fR] [\-t \fIAPI_TOKEN\fR] [\-h]
.SH DESCRICAO
.B tailscale_set_static_ip
e um utilitario em conformidade POSIX desenvolvido para automatizar a realocacao de enderecos IPv4 estaveis dentro de clusters Kubernetes baseados na malha de rede privada Tailscale. Ele evita o provisionamento de IPs aleatorios fora do escopo /24 do Control Plane.
.SH OPCOES
.TP
.BI \-i " IP_ALVO"
Define o endereco IPv4 selecionado via menu interativo para ser cravado na nuvem (ex: 100.100.1.100).
.TP
.BI \-d " DEVICE_ID"
Identificador exclusivo e alfanumerico do dispositivo gerado apos o registro inicial na rede Tailscale.
.TP
.BI \-t " API_TOKEN"
Token de seguranca Bearer obtido dinamicamente via credenciais OAuth da Tailscale.
.TP
.B \-h
Exibe a tela de ajuda padrao com instrucoes resumidas de sintaxe.
.SH EXEMPLOS
Execucao paradoxal direta passando os argumentos extraidos do provisionador:
.IP
tailscale_set_static_ip -i "100.100.1.100" -d "n4vNFveWhp11CNTRL" -t "tskey-api-..."
.SH AUTOR
Desenvolvido pela equipe de Infraestrutura e Redes Leonix.
EOF

# 1. Compacta o arquivo no formato de compactação padrão exigido pelo comando man
gzip -f -9 tailscale_set_static_ip.1

# 2. Desvio de Rota Inteligente (Detecta se o ambiente atual é o NixOS)
if [ -d "/nix/store" ]; then
    echo "[INFO] Ambiente NixOS detectado. Aplicando rota de manpage local..."

    # Cria o diretório de manuais do usuário local se não existir
    mkdir -p "$HOME/.local/share/man/man1"

    # Copia para o repositório local sem o uso do sudo (já que a home pertence ao usuário)
    cp tailscale_set_static_ip.1.gz "$HOME/.local/share/man/man1/"
    echo "[SUCESSO] Manual instalado em: $HOME/.local/share/man/man1/"
else
    echo "[INFO] Ambiente Debian/Ubuntu detectado. Executando rotina padrão de sistema..."

    # 2 (Original). Move o arquivo compactado para o repositório global do Ubuntu
    sudo mv tailscale_set_static_ip.1.gz /usr/share/man/man1/

    # 3 (Original). Atualiza o banco de dados de indexação de manuais do Ubuntu
    sudo mandb -q
    echo "[SUCESSO] Manual instalado em: /usr/share/man/man1/"
fi

# Remove o resíduo limpo do arquivo temporário original
rm -f tailscale_set_static_ip.1
