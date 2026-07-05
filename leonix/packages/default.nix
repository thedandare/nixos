{ pkgs, inputs, ... }:
{
  imports = [
    ./airwaves.nix
    ./databases.nix
    ./development.nix
    ./dns.nix
    ./media-desktop.nix
    ./monitoring.nix
    ./networking.nix
    ./npm-packages.nix
    #     ./pentesting.nix
    ./sys-hardware.nix
    ./security.nix
    ./terminal-utils.nix
    ./test.nix
  ];
  environment.systemPackages = with pkgs; [
    # ⚓ NixOS configuration
    nixos-grub2-theme
    nixfmt
    nixos-artwork.wallpapers.binary-red
    inputs.nixmate.packages.${system}.default
    inputs.labcoat.packages.${system}.default
    #     inputs.letta-code.packages.${system}.default
    nixos-anywhere # Install nixos everywhere via ssh # https://github.com/nix-community/nixos-anywhere

  ];
}
