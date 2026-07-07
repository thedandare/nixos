{ pkgs, ... }:
{

  systemd.services.ubuntu-vm = {
    description = "KUbuntu MicroK8s";
    after = [
      "network.target"
      "tailscaled.service"
    ];
    wantedBy = [ "multi-user.target" ];

    # Do not forcefully kill or restart the VM when 'nixos-rebuild switch' runs
    restartIfChanged = true;

    serviceConfig = {
      Type = "simple"; # Corrigido: 'exec' no script casa perfeitamente com o tipo simple
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStopSec = "5min"; # Tempo máximo que o systemd vai esperar a VM desligar sozinha

      # Comandado de parada: Envia o sinal ACPI de desligamento pelo socket Unix criado pelo QEMU
      ExecStop = pkgs.writeShellScript "stop-ubuntu-k8s-vm" ''
        if [ -S /tmp/ubuntu-k8s-vm.sock ]; then
          echo "Enviando comando de desligamento (ACPI) para a VM Ubuntu K8s..."
          echo "system_powerdown" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:/tmp/ubuntu-k8s-vm.sock

          # Aguarda o processo principal do QEMU ($MAINPID) morrer limpamente
          timeout=20
           while [ $timeout -gt 0 ] && kill -0 $MAINPID 2>/dev/null; do
              sleep 1
              echo $timeout
              timeout=$((timeout - 1))
           done
           echo timeout: $timeout
          echo "VM desligada com sucesso?"
        fi
      '';
    };

    script = ''
            # 🟰 VARIAVEIS
            MEMORY="12288"
            MACHINE="q35"
            SMP="24"
            BRIDGE_IFACE="br0"
      #       SPICE_ADDR=$(ip -f inet -o addr show $BRIDGE_IFACE|cut -d\  -f 7 | cut -d/ -f 1)
            SPICE_ADDR="127.0.0.1"
            SPICE_PORT="5900"
            OVFM_BIOS="/home/leo/emulators/OVMF_CODE_4M.fd"
            MY_VARS_FD="/home/leo/emulators/my_vars.fd"
            PASSTHROUGH_DEVICE="/dev/disk/by-id/nvme-WD_BLACK_SN750_SE_500GB_22064Y801267"
            ID=$EPOCHSECONDS

            # 🟰 DEFINICOES DO QEMUdm
            CDROM="-cdrom /opt/iso/kubuntu-26.04-desktop-amd64.iso"
            PARAM_VM="-enable-kvm -m $MEMORY -cpu host -machine $MACHINE -smp $SMP"
            PARAM_BIOS="-boot menu=on -drive if=pflash,format=raw,readonly=on,file=$OVFM_BIOS -drive if=pflash,format=raw,file=$MY_VARS_FD -device ahci,id=ahci0"
            BRIDGE_NET="-netdev bridge,id=mynet$ID,br=$BRIDGE_IFACE -device virtio-net,netdev=mynet$ID"
            USE_SPICE="-vga qxl" # -chardev spicevmc,id=spicechannel$ID,name=vdagent"
            VIA_SPICE_SOCKET="-spice unix=on,addr=/tmp/spice-kubuntu-vm.sock,disable-ticketing=on"
            VIA_SPICE_IPV4="-spice port=$SPICE_PORT,addr=$SPICE_ADDR,disable-ticketing=on"
            PASS_DISK="-drive file=$PASSTHROUGH_DEVICE,format=raw,if=none,id=physical_sata,cache=none -device ide-hd,drive=physical_sata,bus=ahci0.0"

            # 🆕 Cria a porta de comunicação para enviar comandos à VM
            QEMU_MONITOR="-monitor unix:/tmp/ubuntu-k8s-vm.sock,server,nowait"


            # ⚡ COMANDO SH
            exec ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
              $PARAM_VM \
              $PARAM_BIOS \
              $PASS_DISK \
              $BRIDGE_NET \
              $USE_SPICE $VIA_SPICE_SOCKET \
              $QEMU_MONITOR
    '';
  };
}
