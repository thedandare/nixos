 # Instala o pacote do Tailscale estável de forma nativa
  - curl -fsSL https://tailscale.com/install.sh | sh

  # =========================================================================
  # 🤖 AUTOMAÇÃO VIA API DA TAILSCALE (OAuth Token Exchange)
  # =========================================================================
  # 1. Troca o Client ID e Secret por um Token de Acesso temporário Bearer via API
  - |
    export API_TOKEN=$(curl -s -d "client_id=kxixTezVgB21CNTRL" -d "client_secret=tskey-client-kxixTezVgB21CNTRL-jiN4D8nU7sbYCg1vcCtWrb1nA2D4gRCa" "https://api.tailscale.com/api/v2/oauth/token" | grep -oP '"access_token":"\K[^"]+')

  # 2. Usa o token para fabricar uma Auth Key descartável (válida por 60 segundos) amarrada à sua tag
  # - |
  #   export REQ_KEY=$(curl -s -X POST -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" -d '{"capabilities":{"devices":{"create":{"reusable":false,"ephemeral":true,"preauthorized":true,"tags":["tag:k8s"]}}},"expirySeconds":60}' "https://api.tailscale.com/api/v2/tailnet/-/keys" | grep -oP '"key":"\K[^"]+')
    - |
    export REQ_KEY=$(curl -s -X POST -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" -d '{"capabilities":{"devices":{"create":{"reusable":false,"ephemeral":true,"preauthorized":true,"tags":["tag:teste","tag:canssh"]}}},"expirySeconds":60}' "https://tailscale.com" | grep -oP '"key":"\K[^"]+')


  # 3. Autentica e levanta a interface instantaneamente usando a chave gerada pela API acima
  - tailscale up --auth-key=$REQ_KEY --accept-dns=true  --ssh=true --web-client=true --stateful-filtering=false
  # ====================================================


  -----

  # 1. Garante que os sockets de comunicação do Snap estejam ativos
  - systemctl enable --now snapd.socket snapd.service


#   runcmd:


  - [ echo, "Starting provisioning..." ]
  - git clone https://github.com/thedandare/ubunix.git
  - cd ubunix/nix
  - ./install_nix.sh
  - ./nix_run.sh
  - echo "VM is completely ready!" > /home/ubuntu/status.txt
