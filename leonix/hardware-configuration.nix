{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  #   defaultOptions = "nofail lazytime user X-mount.mkdir=0770 X-mount.owner=leo X-mount.group=users";
  #   defaultNoAuto = " user X-mount.mkdir=0770 X-mount.owner=leo X-mount.group=users";
in
{

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  fileSystems = {
#     #   "shadowing" (sombreamento de diretório).
#     "/home/leo/.cache" = {
#       device = "tmpfs";
#       fsType = "tmpfs";
#       options = [
#         "nosuid"
#         "nodev"
#         "size=16G"
#         "mode=0700"
#         "uid=1000"
#       ];
#     };

    "boot" = {
      #        ATA Lexar SSD NQ100 part8
      mountPoint = "/boot";
      device = "/dev/disk/by-uuid/EF84-E11B";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "EFI" = {
      #        ATA Lexar SSD NQ100 part8
      mountPoint = "/EFI";
      device = "/dev/disk/by-uuid/EF84-E11B";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    # 🚀 SISTEMA RAÍZ EFÊMERO EM RAM (Aceleração Máxima do KDE)
    #     "/" = {
    #       device = "none";
    #       fsType = "tmpfs";
    #       options = [
    #         "defaults"
    #         "size=32G"
    #         "mode=755"
    #       ];
    #     };

    # ATA Lexar SSD NQ100 part4
    "/" = {
      device = "/dev/disk/by-uuid/ef55b11a-d3d2-4f69-9cd5-fb7e0706e108";
      fsType = "ext4";
    };

    #     # O seu SSD sdc5 original passa a guardar apenas o gerador do sistema
    #     "/nix" = {
    #       device = "/dev/disk/by-uuid/ef55b11a-d3d2-4f69-9cd5-fb7e0706e108";
    #       fsType = "ext4";
    #     };

    # A sua NOVA partição de 151GB no SSD para guardar seus arquivos pessoais
    "/home" = {
      device = "/dev/disk/by-uuid/78c7c68f-7cca-413f-97fa-e0de78a22812";
      fsType = "ext4";
    };

    #        ATA Lexar SSD NQ100 part6
    "/opt" = {
      mountPoint = "/opt";
      device = "/dev/disk/by-uuid/85f54a0b-7be3-4c8b-ad21-eeda793b83ee";
      fsType = "ext4";
      neededForBoot = true;
      depends = [ "/" ];

    };

    "A-WD40" = {
      mountPoint = "/a";
      device = "/dev/disk/by-uuid/F078FFD678FF9A14";
      fsType = "ntfs";
      neededForBoot = false;
      noCheck = true;
      options = [
        #         "noauto"
        "user"
      ];

    };

    "B-WD40" = {
      mountPoint = "/b";
      device = "/dev/disk/by-uuid/1054E84354E82CE2";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
      options = [
        "noauto"
        "user"
      ];

      #       options = [
      #         defaultOptions
      #       ];
      #       depends = [ "/a" ];

    };

    "NQ10-Win11" = {
      mountPoint = "mnt/nq10-win11";
      device = "/dev/disk/by-uuid/01DCE55906B2BF60";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
      options = [
        "noauto"
        "user"
      ];

    };

    "NQ10-WinSrv25" = {
      mountPoint = "mnt/nq10-winSrv25";
      device = "/dev/disk/by-uuid/584147C7147C9740";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
      options = [
        "noauto"
        "user"
      ];
    };

    "NQ10-WinEfi" = {
      mountPoint = "mnt/nq10-winEfi";
      device = "/dev/disk/by-uuid/E59F-D619";
      fsType = "vfat";
      noCheck = true;
      neededForBoot = false;
      options = [
        "noauto"
        "user"
      ];

    };

    "L-0day" = {
      mountPoint = "/L";
      device = "/dev/disk/by-uuid/CCE64C7DE64C6A32";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
      options = [
        #         "noauto"
        "user"
      ];

    };

    "M-ST40_ntfs" = {
      mountPoint = "/mnt/st40-M";
      device = "/dev/disk/by-uuid/BE9A24099A23BCB1";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
    };

    "st40-ext4" = {
      device = "/dev/disk/by-uuid/0501a667-289c-4869-bdda-a649de430b27";
      mountPoint = "/mnt/st40-ext4";
      fsType = "ext4";
      neededForBoot = false;

    };

    "/kali" = {
      mountPoint = "/mnt/kali";
      enable = false;

      device = "/dev/disk/by-uuid/b7073fc4-218e-4486-ac06-ac91a7caa392";
      fsType = "ext4";
      noCheck = true;
      neededForBoot = false;

    };

    "/kali/var" = {
      mountPoint = "/mnt/kali/var";
      enable = false;

      device = "/dev/disk/by-uuid/e7e62581-a62b-4734-aed4-696089450ea1";
      fsType = "ext4";
      noCheck = true;
      neededForBoot = false;
      depends = [ "/kali" ];

    };

    "/kali/usr" = {
      mountPoint = "/mnt/kali/usr";
      device = "/dev/disk/by-uuid/a393de66-f6f8-4d96-9028-15ddc2b35ba8";
      fsType = "ext4";
      noCheck = true;
      neededForBoot = false;
      enable = false;
      depends = [ "/kali" ];

    };
  };

  swapDevices = [ ];

}
