# ▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
# ▐                                                                              ▌
# ▐                                                                              ▌
# ▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    sha256 = "sha256:10y7xwm4ykcs3pqyj80ri8vwgwwvzzax32f2vgpqb8qc25xv2sv4";
  };
  #   foo = builtins.getFlake (toString /home/leo/flakes/foo);
  #   myflake = builtins.getFlake (toString /home/leo/myflake);
  #   initCorsairMouse = builtins.getFlake (toString /home/leo/flakes/initCorsairMouse);
  #     /opt/nix-security-box/kubernetes.nix

  #    ./agenix.nix
  #     ./hydra.nix
in
{

  imports = [
    ./hardware-configuration.nix
    ./kernel
    ./networks
    ./packages
    ./programs
    ./services
    ./users
    ./virtualisation
  ];

  /*
      home-manager.useGlobalPkgs = true;
      home-manager.users.leo =
        { pkgs, ... }:
        let
          homePackages = import ./packages.nix;

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
          home.file."osnix" = {
            source = builtins.fetchGit {
              url = repositoryUrl;
              ref = "main";
            };
            # Isso faz com que você possa modificar os arquivos localmente
            recursive = true;
          };
          #       nix.settings.experimental-features = [
          #         "nix-command"
          #         "flakes"
          #       ];
          nixpkgs.config.allowUnfree = true;
          home.packages = homePackages.packages;
          services.mpris-proxy.enable = true; # To make bt buttons for pause/play or to skip to the next track usable.
          programs.chromium.enable = true;
          programs.home-manager.enable = true;
          home.stateVersion = "26.05"; # 🚭 No Changing.

          # ♐ Git
          services.ssh-agent.enable = true;
          home.file.".ssh/leo.ssh.pub".text = userSshKey; # Para q o Home Manager crie o arquivo  .pub na máquina

        };
  */

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };

  # 🗝️ Seguranca
  security.sudo.wheelNeedsPassword = false;

  #  The following rule is the analogue of NOPASSWD:ALL in sudo, in that wheel users do not need to authenticate again when performing any action.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Sao_Paulo";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  system.stateVersion = "25.11"; # 🚭 No Changing.
  /*
    virtualisation.lxc = {
      enable = false;

      # Ativa o lxcfs para isolamento correto de CPU/Memória (opcional, mas recomendado)
      lxcfs.enable = true;

      # Injeta a configuração global que todo container criado irá herdar
      defaultConfig = ''
        # Inclui o perfil padrão de Nesting que vem com o pacote LXC do NixOS
        lxc.include = ${pkgs.lxc}/share/lxc/config/nesting.conf

        # Configurações de montagem para permitir o gerenciamento de cgroups/sys
        lxc.mount.auto = cgroup:rw sys:rw
        lxc.apparmor.profile = unconfined

        # Permite que o container manipule o hardware de loop do host (major number 7)
        lxc.cgroup2.devices.allow = b 7:* rwm
      '';
    };
  */

}
