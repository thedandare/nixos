{ pkgs, inputs, ... }:
{
  imports = [
    ./databases.nix
    ./development.nix
    ./media-desktop.nix
    ./networking.nix
    #     ./pentesting.nix
    ./sys-hardware.nix
    ./security.nix
    ./terminal-utils.nix
  ];
  environment.systemPackages = with pkgs; [
    # ⚓ NixOS configuration
    nixos-grub2-theme
    nixfmt
    nixos-artwork.wallpapers.binary-red
    inputs.nixmate.packages.${system}.default
    inputs.labcoat.packages.${system}.default
  ];
}
