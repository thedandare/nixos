# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
  #   foo = builtins.getFlake (toString /home/leo/flakes/foo);
  #   myflake = builtins.getFlake (toString /home/leo/myflake);
  #   initCorsairMouse = builtins.getFlake (toString /home/leo/flakes/initCorsairMouse);
  #     /opt/nix-security-box/kubernetes.nix

  #    ./agenix.nix
  #     ./hydra.nix
in
{

  imports = [
    ./grub.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./systemPackages.nix
    ./peripherals.nix
    ./services.nix
    ./net-svc/networking.nix
    ./net-svc/samba.nix
    ./git-services.nix
    ./programs.nix
    ./users.nix
    ./qemu-vms.nix
    ./startup.nix
    "${home-manager}/nixos"
    #     (import)

  ];

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

}
