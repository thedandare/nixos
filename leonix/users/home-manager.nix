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
    ./home-packages.nix
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
    };
}
