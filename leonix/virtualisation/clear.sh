#!/bin/sh
rm cloud-init.yaml
incus delete leonk8s --force
./compile-cloudinit.sh

# 1. Cria a sessão com o vncviewer na metade esquerda
tmux new-session -d -s vnc_workspace 'vncviewer -listen 5500'

# 2. Divide a tela verticalmente para rodar o switch na metade direita
# (O socat NÃO é aberto aqui para não travar o split)
tmux split-window -h -p 68 -t vnc_workspace 'nixos-rebuild switch ; incus exec leonk8s journalctl -- -f'

# 3. O PULO DO GATO: Agenda a abertura do popup para o exato momento em que você se conectar
# O 'run-shell' garante que o popup seja desenhado na janela ATIVA do cliente
tmux set-hook -t vnc_workspace client-attached 'display-popup -x C -y C -w 80 -h 24 -E "socat TCP-LISTEN:1234,reuseaddr,fork EXEC:\"../networks/tailscale_choose_ip.sh\""'

# 4. Entra na sessão (O gancho acima vai disparar o popup na sua cara agora!)
tmux attach -t vnc_workspace
