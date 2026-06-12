{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # grub

  # initrd
  boot.initrd.enable = true;
  boot.initrd.kernelModules = [
    "amdgpu"
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "kvm-amd"
    #     "zram"
    "k10temp" # equiv ao coretemp da intel
  ];
  boot.kernelParams = [
    "hugepagesz=2M"
    "hugepages=12000"
    "default_hugepagesz=2M"
    "amd_iommu=on"
    "iommu=pt"
    "processor.max_cstate=4"
    "nohz_full=1-7" # Diz ao kernel que as CPUs de 1 a 7 ficarão sem interrupções periódicas.

  ];

  # Linha 1 (kvm_amd): Ativa a virtualização aninhada (Nested Virtualization).
  #  Linha 2  é usado no Linux para habilitar o DPM (Dynamic Power Management), um recurso do driver amdgpu que controla o gerenciamento de energia e o ajuste dinâmico de clock da placa de vídeo AMD.
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options amdgpu          dpm=1
    options amdgpu          gpu_recovery=1
  '';

  #   boot.extraModulePackages = [ ];
  #   boot.initrd.kernelModules = [ ];

  # Linha 1 (vfio-pci): Diz ao sistema para isolar a sua placa de vídeo AMD e o áudio HDMI assim que o PC ligar.
  #       options vfio-pci ids=1002:67ef,1002:aae0
  #   boot.initrd.postMountCommands = "echo -e '\033[1m' '\033[31m'  initrd montado! Enter para continuar ; read ; echo -e '\033[0m'prosseguindo... ";
  #   Failed assertions:
  #        - systemd stage 1 does not support `boot.initrd.postMountCommands`. Instead, create systemd services using the `boot.initrd.systemd.services` options, which has an API matching the stage 2 `systemd.services` options. Refer to `bootup(7)`, specifically the sections on "Bootup in the Initrd" and "System Manager Bootup", for information about when various units happen, and order services accordingly.

  boot.growPartition = false;

  #   boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}