{ config, pkgs, ... }:
let
  # 1. Importa o flake diretamente da sua pasta local de desenvolvimento
  fiboFlake = builtins.getFlake "path:/home/leo/flakes/fibo-serverpod";

  # 2. Extrai o pacote default compilado por ele
  fiboPackage = fiboFlake.packages.x86_64-linux.default;

  tokenApi = "F1bo6600";

in

{

  services.gnome.gnome-keyring.enable = false;

  programs.ssh.startAgent = true;

  #   systemd.services.socat100 = {
  #     description = "Iniciar sessao tmux com comando em segundo plano";
  #
  #     # Garante que só inicia após a rede e todo o sistema básico estarem prontos
  #     wantedBy = [ "multi-user.target" ];
  #     after = [
  #       "network.target"
  #       "local-fs.target"
  #     ];
  #
  #     # Injeta os pacotes necessários diretamente no ambiente deste serviço
  #     path = with pkgs; [
  #       tmux
  #       python3
  #       bash
  #       coreutils
  #     ];
  #
  #     serviceConfig = {
  #       AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ]; # Permite ao usuário comum abrir portas < 1024
  #       CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ]; # Garante que o processo herde a permissão
  #
  #       #       Type = "forking";
  #       Type = "oneshot";
  #       # FORÇA o uso do binário exato da Nix Store no início para o Systemd não se perder
  #       ExecStart = "${pkgs.socat}/bin/socat -d -d -v TCP4-LISTEN:100,bind=100.100.1.2,fork /home/leo/Desktop/socat100.log";
  #       #       ExecStart = "${pkgs.socat}/bin/socat -d -d -v TCP4-LISTEN:100,bind=100.100.1.2,fork stdout | tee -a /home/leo/Desktop/socat100.log";
  #       #       ExecStart = "${pkgs.tmux}/bin/tmux new -d -s socat100 '${pkgs.socat}/bin/socat -d -d -v TCP4-LISTEN:100,bind=100.100.1.2,fork stdout | tee -a /home/leo/Desktop/socat100.log'";
  #       RemainAfterExit = false;
  #       #       User = "leo"; # Substitua pelo seu nome de usuário para não rodar como root
  #     };
  #   };

  systemd.services.before-graphical-target = {
    description = "graphical.target";
    environment = {
      # Injeta uma variável Nix no ambiente do processo
      API_TOKEN = tokenApi;
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      echo -e "\033[7,39m  Pré graphical-target. "
      ./run/current-system/sw/bin/ckb-next &
      echo -e "\033[0m"
    '';
    wantedBy = [ "graphical.target" ];
  };

  systemd.services.before-multi-user-targeta = {
    description = "multi-user.target";

    # Ensures the script runs once at system boot and finishes
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''

        echo -e '\033[1m' '\033[31m' Normal multi-user mode. Compactando memória e iniciando daemon do mouse '\033[0m'
        echo "CorsairMouse daemon started at $(date)" >> /var/log/initCorsairMouse.log

        ${pkgs.ckb-next}/bin/ckb-next-daemon >> /var/log/initCorsairMouse.log 2>&1 &
            echo -e " '\033[1m' '\033[31m' Forçando o kernel a juntar a RAM antes de alocar os Hugepages '\033[0m'  "
        echo -e " '\033[1m' '\033[21m' Por que no multi-user.target ?"
        echo -e " '\033[1n' '\033[11m' Momento Ideal do Boot: O multi-user.target é o marco do systemd onde os serviços de rede, discos e, no seu caso, as suas VMs do QEMU começam a inicializar (já que o seu script de VMs usa wantedBy multi-user.target."
        echo -e " '\033[0m' '\033[10m' Rodar a compactação aqui garante que a memória seja limpa imediatamente antes do QEMU tentar alocar os 8GB de Hugepages. '\033[0m'"
      echo 1 > /proc/sys/vm/compact_memory
        echo 3 > /proc/sys/vm/drop_caches


    '';
    # Systemd to run this when the system reaches normal multi-user mode
    wantedBy = [ "multi-user.target" ];
  };

  #
#   system.activationScripts.tpmDolphinRootFix = {
#     text = ''
#       # Garante que a pasta local do root exista
#       mkdir -p /root/.local/share
#
#       # Remove links antigos ou vazios para não dar erro de arquivo existente
#       rm -f /root/.local/share/applications
#       rm -f /root/.local/share/mime
#
#       # Cria os links simbólicos apontando para o usuário leo
#       ln -s /home/leo/.local/share/applications /root/.local/share/applications
#       ln -s /home/leo/.local/share/mime /root/.local/share/mime
#
#       # Dá permissão de leitura para o root acessar a pasta do leo
#       chmod o+rx /home/leo /home/leo/.local /home/leo/.local/share
#     '';
#   };

}
