{
  config,
  lib,
  pkgs,
  rtl8851bu-src,
  modulesPath,
  ...
}:
let
  /*
    rtl8851bu-driver = config.boot.kernelPackages.stdenv.mkDerivation {
      pname = "rtl8851bu";
      version = "git";
      src = rtl8851bu-src;

      nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

      # Tell the Makefile where the Nix kernel build tree lives
      makeFlags = [
        "KSRC=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
      ];

      # Copy the compiled .ko kernel module into the proper Nix output path
      installPhase = ''
        mkdir -p $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/kernel/drivers/net/wireless/
        cp 8851bu.ko $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/kernel/drivers/net/wireless/
      '';
    };
  */
in
{
  boot.initrd.enable = true;
  #boot.extraModulePackages = [ rtl8851bu-driver ];
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
  boot.initrd.systemd.fido2.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "kvm-amd"
    "k10temp" # equiv ao coretemp da intel
    "loop"
    "fuse"
    "overlay"
    "squashfs"
    # Obrigatório para Funcionamento do Incus
    "br_netfilter"
    # NAO FUNCIONA MAIS
    "ip_tables"
    #     "iptable_filter"
    #     "iptable_nat"
    #     "dvb-usb-rtl28xxu"
    "8851bu"
    "rbd"

  ];
  boot.kernelParams = [
    "boot.trace"
    "boot.shell_on_fail"
    "hugepagesz=2M"
    "hugepages=12000"
    "default_hugepagesz=2M"
    "amd_iommu=on"
    "iommu=pt"
    "processor.max_cstate=4"
    "nohz_full=1-2" # Diz ao kernel que as CPUs de 1 a 7 ficarão sem interrupções periódicas.
    "modprobe.blacklist=dvb_usb_rtl28xxu"
  ];
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "fs.file-max" = 100000;

    "net.ipv4.ip_forward" = 1;
  };
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65535";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "65535";
    }
  ];
  # Linha 1 (kvm_amd): Ativa a virtualização aninhada (Nested Virtualization).
  #  Linha 2  é usado no Linux para habilitar o DPM (Dynamic Power Management), um recurso do driver amdgpu que controla o gerenciamento de energia e o ajuste dinâmico de clock da placa de vídeo AMD.
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options amdgpu          dpm=1
    options amdgpu          gpu_recovery=1
    options bluetooth enable_ecred=1
  ''; # ecred > Pairing hearing aids using the ASHA protocol

  # Linha 1 (vfio-pci): Diz ao sistema para isolar a sua placa de vídeo AMD e o áudio HDMI assim que o PC ligar.
  #       options vfio-pci ids=1002:67ef,1002:aae0
  #   boot.initrd.postMountCommands = "echo -e '\033[1m' '\033[31m'  initrd montado! Enter para continuar ; read ; echo -e '\033[0m'prosseguindo... ";
  #   Failed assertions:
  #        - systemd stage 1 does not support `boot.initrd.postMountCommands`. Instead, create systemd services using the `boot.initrd.systemd.services` options, which has an API matching the stage 2 `systemd.services` options. Refer to `bootup(7)`, specifically the sections on "Bootup in the Initrd" and "System Manager Bootup", for information about when various units happen, and order services accordingly.

  boot.growPartition = false;
  boot.supportedFilesystems = [
    "squashfs"
    "fuse"
  ];
  programs.fuse.userAllowOther = true;
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53; # liberando pro pi hole.

  #   boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
