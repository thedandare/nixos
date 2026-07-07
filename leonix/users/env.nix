{ ... }:
let
  tmuxSessionHandler = ../scripts/handle_tmux_client_and_session.sh;
  scriptForNixosBuildName = ../scripts/popup_for_nixos_build_name.sh;
  # Lê o arquivo e remove possíveis quebras de linha no final
  openai_key = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ../secret/openai_key);
  # Gerenciamento rápido das VMs
  makeRestartVmScript =
    serviceName:
    ''sudo journalctl -u ${serviceName} -f -n 0 > /dev/tty 2>&1 & sleep 1 && echo -e "\n\e[1;31m[=== PARANDO O SERVIÇO: ${serviceName} ===]\e[0m" && sudo systemctl stop ${serviceName} && echo -e "\n\e[1;32m[=== INICIANDO O SERVIÇO: ${serviceName} ===]\e[0m" && sudo systemctl start ${serviceName} && echo -e "\n\e[1;34m[=== PRONTO! MONITORANDO LOGS AO VIVO (Ctrl+C para sair) ===]\e[0m"'';

  makeOpenVmScript = serviceName: ''
    journalctl -u ${serviceName} -f -n 0 > /dev/tty 2>&1 & sleep 1 \
    && echo -e "\n\e[1;31m[=== Iniciando o Spicy: ${serviceName} ===]\e[0m" \
    && remote-viewer spice+unix:///home/leo/emulators/socks/${serviceName}-spice.sock \
    && echo -e "\n\e[1;32m[=== AGUARDANDO O SERVIÇO: ${serviceName} ===]\e[0m" \
    && echo -e "\n\e[1;34m[===  Ctrl+C para sair ===]\e[0m"
  '';
in
{
  environment.variables.EDITOR = "nvim";
  environment.variables.OPENAI_API_KEY = openai_key;
  environment.variables.GIT_SSH_COMMAND = "ssh -i ~/.ssh/tdd_id_ed25519";

  environment.interactiveShellInit = ''
    alias gs='git status'
    alias vim='nvim'
     alias Edt='tmux new-window edit'B
     alias Spl='tmux split-window edit'
  '';

  environment.shellAliases = {
    df = ''/run/current-system/sw/bin/df && echo -e "\033[7;36m \n 🪬 \n Lembre-se de\n    usar o dysk:\033[0m" && dysk # '';

    su = "sudo su";
    su- = "sudo su -";
    suleo = "su leo -";
    vi = "nvim";
    vim = "gnvim";
    #     cd.. = "cd ..";

    E = "tmux split-window edit";
    e = "exit 0";
    Bt = "sudo nixos-rebuild boot  --show-trace";
    Tst = "sudo nixos-rebuilsld test  --show-trace";
    Sw = "sudo nixos-rebuild switch  --show-trace --print-build-logs --verbose";
    Rbt = "sudo shutdown -r now";
    cdn = "cd /etc/nixos";
    Cdn = "cd /etc/nixos";
    Ntrst = "systemctl restart network-online.target accounts-daemon.service NetworkManager";

    UbntRst = makeRestartVmScript "ubuntu-vm.service"; # 🚨 Este nome tem que bater com o configurado em startup.nix!
    WinRst = makeRestartVmScript "windows-server.service"; # 🚨 Este nome tem que bater com o configurado em startup.nix!
    SockUbnt = makeOpenVmScript "ubuntu-vm"; # 🚨 Este nome tem que bater com o configurado em qemu-vms.nix!
    SockWin = makeOpenVmScript "windows-server"; # 🚨 Este nome tem que bater com o configurado em qemu-vms.nix!
    JctlWin = "journalctl -u windows-server.service -e --no-page";
    JctlUbnt = "journalctl -u ubuntu-vm.service -e --no-page";

    OsnixCP = ''
      if [ "$EUID" -ne 0 ]; then
        echo "Error:   run as root." >&2
        exit 1
      fi
      cd /osnix/nixos
      git pull
      ./rsync.sh
      ./clear_temp_files.sh
      ./pu.sh
      cd ../ubunix
      git pull
      ./clear_temp_files.sh
      ./pu.sh

    '';
    #

    Swl = ''
      ${tmuxSessionHandler}
      sleep 2
      ${scriptForNixosBuildName}
    '';

    "gs" = "git status";
    "teste" = "echo teste";
    "-g" = ".....=../../../..";
  };
  #   # Opcional: Garante que o diretório seja criado na inicialização se não existir
  #   systemd.tmpfiles.rules = [
  #     "d /run/user/0 0700 root root -"
  #   ];
  environment.sessionVariables = rec {

    S = "/etc/nixos/startup.nix";
    C = "/etc/nixos/configuration.nix";
    H = "/etc/nixos/hardware-configuration.nix";

    # Garante que as vars sejam injetadas no ambiente do root

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

}
