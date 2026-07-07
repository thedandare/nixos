{ pkgs, ... }:
{
  # 1. Habilita o Libvirtd nativo e injeta os pacotes de firmware UEFI (OVMF) de forma correta
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "br0" ];
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;

      # Ativa nativamente os patches de caminho imutável para o arquivo OVMF UEFI no NixOS
      #       ovmf = {
      #         enable = true;
      #         package = pkgs.OVMFFull.fd; # Mapeia os arquivos binários estáveis de BIOS
      #       };
      # 🚨 The 'virtualisation.libvirtd.qemu.ovmf' submodule has been removed. All OVMF images distributed with QEMU are now available by default.

    };
  };

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "br0"
    ];

    #B   # https://github.com/NixOS/nixpkgs/issues/34972
    qemuVerbatimConfig = ''
      namespaces = []
       cgroup_device_acl = [
           "/dev/null", "/dev/full", "/dev/zero",
           "/dev/random", "/dev/urandom",
           "/dev/ptmx", "/dev/kvm"
       ]
       bridge_helper = "${pkgs.qemu}/libexec/qemu-bridge-helper"
    '';
    onBoot = "ignore";
  };
  programs.virt-manager.enable = true;

  systemd.services.libvirt-guests = {
    wantedBy = lib.mkForce [ ];
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };
  # Enable TPM emulation (optional)
  # install pkgs.swtpm system-wide for use in virt-manager (optional)
  #   virtualisation.libvirtd.qemu = {
  #     swtpm.enable = true;
  #   };

  # Permite gerenciamento sem travas de privilégios para o root
  users.groups.libvirtd.members = [
    "root"
    "leo"
  ];

  /*
    # 2. Registra o XML de forma limpa no boot do sistema usando uma Systemd One-Shot unit
    systemd.services.initialize-ubuntu-kvm = {
      description = "Garante que a VM Ubuntu com disco fisico esteja sincronizada no KVM";
      after = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];

      # Injeta os binários necessários no escopo do serviço (libvirt/virsh)
      path = [
        pkgs.libvirt
        pkgs.coreutils
        pkgs.gnugrep
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        echo -e '\033[1m' '\033[31m'  Agora Vai '\033[0m'
      '';
    };
  */
}
#
#  script = ''
#       # Caminho onde vamos salvar temporariamente o XML gerado pelo NixOS
#       XML_PATH="/var/lib/libvirt/qemu/ubuntu-k8s-node.xml"
#
#       # Garante a existência da pasta padrão de NVRAM do Libvirt
#       mkdir -p /var/lib/libvirt/qemu/nvram/
#
#       # Escreve o XML imutável direto na pasta do Libvirt
#       cat << 'EOF' > $XML_PATH
#       ${builtins.readFile ./kubuntu-qemu.xml}
#       EOF
#
#       # Se a VM não existir no sistema, define (registra) ela e dá o boot
#       if ! virsh dominfo ubuntu-k8s-node >/dev/null 2>&1; then
#         virsh define $XML_PATH
#         virsh start ubuntu-k8s-node
#       fi
#     '';
