{ pkgs, ... }:

{

  imports = [
    ./drivers/audio.nix
    ./drivers/bluetooth.nix
    ./drivers/printers.nixfp
    ./drivers/radeon.nix
    ./drivers/ryzen.nix
  ];

  # ⌨️ Keymap
  console.keyMap = "us";

  # 📻 SDR
  hardware.rtl-sdr.enable = true; # Lembrar de add users.users.<name>.extraGroups = [ "plugdev" ];

  # 📳 Touchpad support
  services.libinput.enable = true;

}
