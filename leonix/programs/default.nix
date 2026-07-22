{ pkgs, ... }:

{

  # 1. Enable the native ydotool system service and driver
  programs.ydotool.enable = true;

  imports = [ ./shells.nix ];
  #   programs.nixbit.enable = true; # A GUI application for updating your NixOS system from a Nix Flakes Git repository.

  #   programs.nixbit.forceAutostart = true;

  programs.npm.enable = true;

  programs.pulseview.enable = true; # A sigrok GUI.
  programs.skim.enable = true; # skim fuzzy finder.
  programs.skim.keybindings = true; # https://github.com/skim-rs/skim

  programs.cfs-zen-tweaks.enable = true;
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 10;
    };

    # Warning: GPU optimisations have the potential to damage hardware
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
      amd_performance_level = "high";
    };

    custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    };
  };
  programs.gpu-screen-recorder.enable = true;

  programs.tmux = {
    enable = true;
    aggressiveResize = false; # default false
    baseIndex = 1; # default 0
    historyLimit = 20000; # default 2000
    #     shortcut = " "; # default b
    #     terminal = "bt"; # default screen
    resizeAmount = 15; # default 5
    keyMode = "vi"; # one of "emacs", "vi"
    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      #       (pkgs.tmuxPlugins.catppuccin.overrideAttrs (_: {
      #         src = pkgs.fetchFromGitHub {
      #           owner = "Millrocious";
      #           repo = "tmux";
      #           rev = "f71e781b56a45c97dfaa6519bc2914837a9b5f78";
      #           sha256 = "sha256-fJlQYstWEk3y1kJxoY+ylJ8vU9zTeidDr/vIp9ZtubM=";
      #         };
      #       }))
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.sidebar
      pkgs.tmuxPlugins.tmux-session-manager # https://github.com/PhilVoel/tmux-session-manager
      pkgs.tmuxPlugins.fingers # https://github.com/Morantron/tmux-fingers
      pkgs.tmuxPlugins.fzf-tmux-url # Quickly open urls on your terminal screen

    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -n M-H previous-window
      bind -n M-L next-window

      #bind-key -n C-f display-popup -w 80% -h 80% -E "fzf"
      # Correção: Usa -T root em vez de -n para evitar erro de suporte
      bind-key -T root C-f display-popup -w 80% -h 80% -E "fzf"


      source /home/leo/.tmux.conf
    '';
  };

  #   programs.anyrun = {
  #     enable = true;
  #     config = {
  #       x = {
  #         fraction = 0.5;
  #       };
  #       y = {
  #         fraction = 0.3;
  #       };
  #       width = {
  #         fraction = 0.3;
  #       };
  #       hideIcons = false;
  #       ignoreExclusiveZones = false;
  #       layer = "overlay";
  #       hidePluginInfo = false;
  #       closeOnClick = false;
  #       showResultsImmediately = false;
  #       maxEntries = null;
  #
  #       plugins = [
  #         "${pkgs.anyrun}/lib/libapplications.so"
  #         "${pkgs.anyrun}/lib/libsymbols.so"
  #       ];
  #     };
  #
  #     # Inline comments are supported for language injection into
  #     # multi-line strings with Treesitter! (Depends on your editor)
  #     extraCss = /* css */ ''
  #       .some_class {
  #         background: red;
  #       }
  #     '';
  #
  #     extraConfigFiles."some-plugin.ron".text = ''
  #       Config(
  #         // for any other plugin
  #         // this file will be put in ~/.config/anyrun/some-plugin.ron
  #         // refer to docs of xdg.configFile for available options
  #       )
  #     '';
  #   };

  programs.atuin.daemon.enable = true;
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      auto_sync = true;
      sync_frequency = "1m";
      sync_address = "https://api.atuin.sh";
      search_mode = "prefix";
    };
  };

  programs.bat.enable = true; # A cat(1) clone with wings.
  #   programs.bat.extraPackages = [
  #     batdiff
  #     batman
  #     prettybat
  #   ];
  programs.bat.settings = {
    italic-text = "always";
    map-syntax = [
      "*.ino:C++"
      ".ignore:Git Ignore"
    ];
    pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
    paging = "never";
    theme = "TwoDark";
  };
  # 2. Set Zsh as the default shell for your user
  users.users.leo = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  # Install programs.
  programs.fcast-receiver.enable = true;
  programs.firefox.enable = true;
  programs.chromium.homepageLocation = "https://beta.fiboapp.com.br";
  programs.chromium.enable = true;
  programs.chromium.enablePlasmaBrowserIntegration = true;

  programs.git.enable = true;
  programs.gnome-disks.enable = true;
  programs.gpaste.enable = true;
  programs.java.enable = true;
  programs.nautilus-open-any-terminal.enable = true;

  programs.partition-manager.enable = true;
  programs.thunar.enable = true;
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    # for more info take a look at https://wiki.archlinux.org/title/Wayland#Xwayland
    xwayland.enable = true;
  };
  programs.yazi.enable = true;
  programs.zmap.enable = true;
  programs.zoxide.enable = true;
  #     services.x2goserver.enable = true;
  # Configuração corrigida do Neovim para NixOS (global)
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    configure = {
      # 1. Lista de Plugins instalados
      packages.myVimPackages = {
        start = with pkgs.vimPlugins; [
          ChatGPT-nvim
          moveline-nvim
          GPTModels-nvim
          dart-vim-plugin
          conform-nvim # Adicionado aqui na lista
          fzf-lsp-nvim
        ];
      };

      # 2. Configurações gerais e scripts Lua/Vim
      customRC = ''
        " Configurações do conform.nvim em Lua
        lua << EOF
          require("conform").setup({
            formatters_by_ft = {
              nix = { "nixfmt" },
            },
            format_on_save = {
              timeout_ms = 500,
              lsp_fallback = true,
            },
          })
        EOF
      '';
    };
  };

  # https://github.com/nix-community/nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    # flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
  };
}
