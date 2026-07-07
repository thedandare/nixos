{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix search flake: radeon
    # [0;1mlegacyPackages.x86_64-linux.[32;1mradeon[0;1m-profile[0m # Application to read current clocks of AMD [32;1mRadeon[0m cards
    # [0;1mlegacyPackages.x86_64-linux.[32;1mradeon[0;1mtools[0m # Lowlevel tools to tweak register and dump state on [32;1mradeon[0m GPUs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mradeon[0;1mtop[0m # Top-like tool for viewing AMD [32;1mRadeon[0m GPU utilization
    # [0;1mlegacyPackages.x86_64-linux.xf86-video-amdgpu[0m # Xorg driver for AMD [32;1mRadeon[0m GPUs using the amdgpu kernel driver
    # [0;1mlegacyPackages.x86_64-linux.xf86-video-ati[0m # ATI/AMD [32;1mRadeon[0m video driver for the Xorg X server
    # [0;1mlegacyPackages.x86_64-linux.xf86videoamdgpu[0m # Xorg driver for AMD [32;1mRadeon[0m GPUs using the amdgpu kernel driver
    # [0;1mlegacyPackages.x86_64-linux.xf86videoati[0m # ATI/AMD [32;1mRadeon[0m video driver for the Xorg X server
  ];
}
