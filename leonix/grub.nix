{
  pkgs,
  lib,
  config,
  ...
}:
let
  theme = pkgs.nixos-grub2-theme;
  /*
    (
      pkgs.nixos-grub2-theme.override {
        withBanner = "the quieter you become the more you are able to hear -- Rumi";
        withStyle = "dark"; # Opções: light, dark, orange, bigSur

      }
    );

      pkgs.fetchFromGithub {
        owner = "vinceliuice";
        repo = "Elegant-grub2-themes";
        rev = "7caa304b349ee638481935d5e0d82b33033b0b1c";
        sha256 = "";
      }
  */
in
{
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      mirroredBoots = [
        {
          devices = [
            "/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T"
          ];
          path = "/boot/EFI";
        }
      ];
      device = "nodev";
      devices = [ "nodev" ]; # Required for EFI; do not point to a specific block device
      #       device = "/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T";
      #       devices = [ "/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T" ]; # Required for EFI; do not point to a specific block device
      theme = theme;
      splashImage = "/etc/nixos/theming/Earth_From_the_Perspective_of_Artemis_II.jpg"; # O caminho deve ser relativo ao arquivo .nix
      useOSProber = false;
      gfxmodeBios = "800x450";
      gfxmodeEfi = "800x450";
      memtest86.enable = true;
      splashMode = "normal";
      fontSize = 25;
      font = "/etc/nixos/theming/BlackOpsOne-Regular.ttf";
      extraEntries = ''
        menuentry "" {
          insmod chain
          insmod ntfs
          set root=(hd2,gpt2)
          chainloader +1
        }
      '';
    };

  };

}
