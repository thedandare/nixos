{ pkgs, ... }:
let
  nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  #    home-manager = {
  #       url = "github:nix-community/home-manager";
  #     };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    sha256 = "sha256:10y7xwm4ykcs3pqyj80ri8vwgwwvzzax32f2vgpqb8qc25xv2sv4";
    #
  };

in
{

  imports = [
    "${home-manager}/nixos"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.leo =
    { pkgs, ... }:
    let
      #  imports = [
      #     ./packages.nix
      #   ];
      repositoryName = "nixos";
      repositoryUser = "thedandare";
      repositoryUrl = "git@github.com:${repositoryUser}/${repositoryName}.git"; # Usando SSH
      userSshKey =
        if builtins.getEnv "SSH_KEY" != "" then
          builtins.getEnv "SSH_KEY"
        else
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICs+sOj/1GK5exkDkCw7H7zmDapshfWaRn474qxZxSUY leo";

    in
    {
      nixpkgs.config = {
        permittedInsecurePackages = [ "googleearth-pro-7.3.7.1155" ];
      };

      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
          };
        };
      };
      # Isso criará uma pasta física para o rep.
      #       home.file."osnix" = {
      #         source = builtins.fetchGit {
      #           url = repositoryUrl;
      #           ref = "main";
      #         };
      #         # Isso faz com que você possa modificar os arquivos localmente
      #         recursive = true;
      #       };
      #       nix.settings.experimental-features = [
      #         "nix-command"
      #         "flakes"
      #       ];
      nixpkgs.config.allowUnfree = true;
      services.mpris-proxy.enable = true; # To make bt buttons for pause/play or to skip to the next track usable.
      programs.chromium.enable = true;
      programs.home-manager.enable = true;
      home.stateVersion = "26.05"; # 🚭 No Changing.

      # ♐ Git
      services.ssh-agent.enable = true;
      home.file.".ssh/leo.ssh.pub".text = userSshKey; # Para q o Home Manager crie o arquivo  .pub na máquina

      home.packages = with pkgs; [
        # 🪚 Configuration
        pkgs.chezmoi # Manage your dotfiles across multiple machines, securely https://www.chezmoi.io

        # 🔍 Search and Destroy
        pkgs.kdePackages.kfind

        pkgs.kdePackages.bluedevil
        pkgs.kdePackages.calendarsupport
        pkgs.kdePackages.drumstick
        pkgs.kdePackages.dynamic-workspaces
        pkgs.kdePackages.k3b
        pkgs.kdePackages.kdeedu-data
        pkgs.kdePackages.kcolorpicker
        pkgs.kdePackages.kcolorchooser
        pkgs.kdePackages.kgraphviewer
        pkgs.kdePackages.kgeography
        pkgs.gravit # visually stunning gravity simulator, https://github.com/gak/gravit

        pkgs.atool # Manage file archives of various types.

        pkgs.httpie # (pronounced aitch-tee-tee-pie)
        # is a command-line HTTP client. Its goal is to make CLI interaction with web services as human-friendly as possible. HTTPie is designed for testing, debugging, and generally interacting with APIs & HTTP servers. The http & https commands allow for creating and sending arbitrary HTTP requests. They use simple and natural syntax and provide formatted and colorized output.
        pkgs.httpie-desktop

        #     pkgs.googleearth-pro

        pkgs.lockbook-desktop

        # 🎳 Gaming
        #         pkgs.rpcs3 # PS3 emulator/debugger
        pkgs.zsnes
        #     pkgs.retroarch-full
        #     pkgs.retroarch-bare
        #     pkgs.retroarch-joypad-autoconfig
        #     pkgs.retroarch-assets

        # ⏬ Downloading
        pkgs.yt-dlp # yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.
        pkgs.media-downloader # front end to yt-dlp, youtube-dl, gallery-dl, lux, you-get, svtplay-dl, aria2c, wget and safari books.
        pkgs.lux # Fast and simple video download library and CLI tool written in Go [https://github.com/iawia002/lux]
        pkgs.aria2 # Lightweight, multi-protocol, multi-source, command-line download utility [https://aria2.github.io/]

        # 📻 Multimedia
        pkgs.plex-desktop
        pkgs.plexamp

        # KDE Customization
        pkgs.kdePackages.karousel

        # KDE tools
        pkgs.kdePackages.kbookmarks # [http://invent.kde.org/frameworks/kbookmarks] manipulate bookmarks using XBEL (https://pyxml.sourceforge.net/topics/xbel/) format.
        pkgs.kdePackages.kde-cli-tools # [https://invent.kde.org/plasma/kde-cli-tools]  a core software package provided by the KDE Community that bundles essential CLI utilities.
        #                 These tools bridge the gap between the terminal and the graphical env., allowing you to trigger actions, modify file assoc, and manage KDE.
        #   🪛 kde-open: Opens any file or URL using the user's preferred default application configured in Plasma.
        #   🪛 kioclient: A cmd net assist that interacts  with KDE’s network transparency layer (KIO slaves),
        #        allowing you to copy, move, or make directories over protocols like FTP, SFTP, and SMB.
        #   🪛 keditfiletype: Modifies file type associations and MIME type assignments from the command line.
        #   🪛 kmimetypefinder: Detects the precise MIME type of a sxpecified file or layout.
        #   🪛 kde-inhibit: Prevents the system from sleeping, locking, or dimming the screen while a specific command runs.
        #   🪛 kstart: Launches graphical applications with specific structural commands, such as forcing them to open
        #        full screen, iconified, or on a specific virtual desktop.
        #   🪛 kinfo: Fetches centralized hardware and software system overview details  from the command line.
        #   🪛 kbroadcastnotification: Triggers standard Plasma system desktop notifications programmatically.
        #   🪛 plasma-open-settings: Commands the desktop environment to directly open specific modules inside System Settings.
      ];

    };
}
