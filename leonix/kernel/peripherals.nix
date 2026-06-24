{ pkgs, ... }:

{

  imports = [
    ../drivers/printers.nix
    ../drivers/radeon.nix
    ../drivers/ryzen.nix
  ];

  # ⌨️ Keymap
  console.keyMap = "us";

  # 📻 SDR
  hardware.rtl-sdr.enable = true; # Lembrar de add users.users.<name>.extraGroups = [ "plugdev" ];

  # 📳 Touchpad support
  services.libinput.enable = true;

}
