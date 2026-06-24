{ ... }:
let
in
{
  environment.variables.EDITOR = "nvim";

  environment.interactiveShellInit = ''
    alias gs='git status'
    alias vim='nvim'
     alias Edt='tmux new-window edit'
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
    Bt = "sudo nixos-rebuild boot  --show-trace";
    Tst = "sudo nixos-rebuilsld test  --show-trace";
    Sw = "sudo nixos-rebuild switch  --show-trace --print-build-logs --verbose";
    Rbt = "sudo shutdown -r now";
    cdn = "cd /etc/nixos";
    Cdn = "cd /etc/nixos";
    Ntrst = "systemctl restart network-online.target accounts-daemon.service NetworkManager";


  };
  environment.sessionVariables = rec {

    S = "/etc/nixos/startup.nix";
    C = "/etc/nixos/configuration.nix";
    H = "/etc/nixos/hardware-configuration.nix";

    # Garante que as vars sejam injetadas no ambiente do root

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_RUNTIME_DIR = "/run/user/0";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

}
