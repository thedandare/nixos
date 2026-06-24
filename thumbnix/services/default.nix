{ pkgs, ... }:
{

  imports = [
    ./startup.nix
    ./tailscale.nix
  ];
}
