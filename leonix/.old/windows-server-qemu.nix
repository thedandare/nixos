let
  constants = import ./constants.nix;
  # Variáveis locais de identificação
  VM_ID = "window-server";
  MAC_ADDR = "52:54:00:AB:12:34";
  PASSTHROUGH_DEVICE = "/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T";

  # Construção dos caminhos com base no HOME do constants.nix
  SOCK_ADDR = "${constants.HOME}/${VM_ID}-spice.sock";
  MONITOR_SOCK = "${constants.HOME}/${VM_ID}-vm.sock";
  OVFM_VARS = "${constants.HOME}/${VM_ID}_vars.fd";

  # Montagem dos parâmetros agregando o arquivo de constants externo
  VM_PARAMS = "${constants.MACHINE} ${constants.MEMORY} ${constants.SMP}";
  BOOT_PARAMS = "-boot menu=on ${constants.EFI_DRIVE} -drive if=pflash,format=raw,file=${OVFM_VARS} -device ahci,id=ahci0";

  # Discos e Redes
  PASS_DISK = "-drive file=${PASSTHROUGH_DEVICE},format=raw,if=none,id=physical_sata,cache=none -device ide-hd,drive=physical_sata,bus=ahci0.0";
  BRIDGE_NET = "-netdev bridge,id=${VM_ID}net,br=${constants.BRIDGE_IFACE} -device virtio-net,netdev=${VM_ID}net,mac=${MAC_ADDR}";

  # Interfaces de gerenciamento
  SPICE_SOCKET = "-vga qxl -spice addr=${SOCK_ADDR},unix=on,disable-ticketing=on";
  SPICE_CHARDEV = "-chardev spicevmc,id=${VM_ID}-spicechannel,name=vdagent";
  QEMU_MONITOR = "-monitor unix:${MONITOR_SOCK},server,nowait";
in
{ pkgs, ... }:
{
  # 3. O serviço que vai rodar o seu comando original no boot
  systemd.services.Windows-server-vm = {
    description = "Windows Server MicroK8s";
    after = [
      "network.target"
      "tailscaled.service"
    ];
    wantedBy = [ "multi-user.target" ];

    restartIfChanged = true; # Disable to not forcefully kill or restart the VM when switch runs

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStopSec = "1min"; # Tempo total máximo que o NixOS vai esperar o Windows fechar

      ExecStop = pkgs.writeShellScript "stop-windows-vm" ''
        if [ -S "${MONITOR_SOCK}" ]; then
          echo "🌙 Enviando comando de desligamento ACPI para a VM ${VM_ID}..."
          echo "system_powerdown" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"${MONITOR_SOCK}"

          timeout=60
          while [ $timeout -gt 0 ] && kill -0 $MAINPID 2>/dev/null; do
            sleep 1
            timeout=$((timeout - 1))
          done

          if kill -0 $MAINPID 2>/dev/null; then
            echo "⚠️ A VM ${VM_ID} travou ou ignorou o sinal. Forçando finalização (SIGKILL)..."
            kill -SIGKILL $MAINPID
          else
            echo "✅ VM ${VM_ID} desligada com sucesso."
          fi
        else
          echo "❌ Socket do monitor não foi encontrado em ${MONITOR_SOCK}. Forçando encerramento do processo..."
          kill -SIGTERM $MAINPID
        fi
      '';
    };

    script = ''
      COMANDO="${constants.WIN_SRV_CDROM} ${constants.WIN_VIRTIO_CDROM} ${VM_PARAMS} ${BOOT_PARAMS} ${PASS_DISK} ${BRIDGE_NET} ${SPICE_SOCKET} ${SPICE_CHARDEV} ${QEMU_MONITOR} ${constants.PASS_WD40} ${constants.PASS_ST40} ${constants.PASS_ST10}"

      echo -e '\033[1m\033[31mIniciando a VM ${VM_ID}\033[0m'
      echo "qemu-system-x86_64 $COMANDO"

      exec ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 $COMANDO
    '';
  };
}
# qemu-system-x86_64  -cdrom /opt/iso/virtio-win-0.1.285.iso -enable-kvm -m 8192 -cpu host -machine q35 -smp 24 -boot menu=on -drive if=pflash,format=raw,readonly=on,file=/home/leo/emulators/OVMF_CODE_4M.fd -drive if=pflash,format=raw,file=/home/leo/emulators/my_vars.fd -device ahci,id=ahci0 -drive file=/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T,format=raw,if=none,id=physical_sata,cache=none -device ide-hd,drive=physical_sata,bus=ahci0.0 -netdev bridge,id=mynet1,br=br0 -device virtio-net,netdev=mynet1 -vga qxl -spice port=5901,addr=192.168.0.14,disable-ticketing=on -chardev spicevmc,id=spicechannel1780694867,name=vdagent -monitor unix:/tmp/windows-server-vm.sock,server,nowait -drive file=/dev/disk/by-id/ata-WDC_WD40PURZ-85TTDY0_WD-WCC7K2ZF3NT1,format=raw,if=none,id=physical_ata1,cache=none -device ide-hd,drive=physical_ata1,bus=ahci0.1 -drive file=/dev/disk/by-id/ata-ST4000VX016-3CV104_WW60QZE2,format=raw,if=none,id=physical_ata2,cache=none -device ide-hd,drive=physical_ata2,bus=ahci0.2 -drive file=/dev/disk/by-id/ata-ST1000DM010-2EP102_ZN1LPA8P,format=raw,if=none,id=physical_ata3,cache=none -device ide-hd,drive=physical_ata3,bus=ahci0.3 -netdev bridge,id=mynet1,br=br0 -device virtio-net,netdev=mynet1 -vga qxl -spice port=5901,addr=192.168.0.14,disable-ticketing=on -chardev spicevmc,id=spicechannel1780694867,name=vdagent

#  qemu-system-x86_64 -cdrom /opt/iso/Windows_InsiderPreview_Server_vNext_en-us_29595.iso -enable-kvm -m 12288 -cpu host -machine q35 -smp 24 -boot menu=on -drive if=pflash,format=raw,readonly=on,file=/home/leo/emulators/OVMF_CODE_4M.fd -drive if=pflash,format=raw,file=/home/leo/emulators/my_vars.fd -device ahci,id=ahci0 -drive file=/dev/disk/by-id/ata-Lexar_SSD_NQ100_1TB_QE6068R0049370S30T,format=raw,if=none,id=physical_sata,cache=none -device ide-hd,drive=physical_sata,bus=ahci0.0 -netdev bridge,id=mynet1780821904,br=br0 -device virtio-net,netdev=mynet1780821904 -vga qxl -spice addr=/home/leo/spice-windows-server-vm.sock,unix=on,disable-ticketing=on  -monitor unix:/tmp/windows-server-vm.sock,server,nowait -drive file=/dev/disk/by-id/ata-WDC_WD40PURZ-85TTDY0_WD-WCC7K2ZF3NT1,format=raw,if=none,id=physical_ata1,cache=none -device ide-hd,drive=physical_ata1,bus=ahci0.1 -drive file=/dev/disk/by-id/ata-ST4000VX016-3CV104_WW60QZE2,format=raw,if=none,id=physical_ata2,cache=none -device ide-hd,drive=physical_ata2,bus=ahci0.2 -drive file=/dev/disk/by-id/ata-ST1000DM010-2EP102_ZN1LPA8P,format=raw,if=none,id=physical_ata3,cache=none -device ide-hd,drive=physical_ata3,bus=ahci0.3
#       SPICE_ADDR="127.0.0.1" #$(ip -f inet -o addr show $BRIDGE_IFACE|cut -d\  -f 7 | cut -d/ -f 1) SPICE_PORT="5901"
#       SPICE_IPV4="-vga qxl -spice port=$SPICE_PORT,addr=$SPICE_ADDR,disable-ticketing=on"
# O socat precisa sempre de dois argumentos (origem e destino). Nessa linha, os argumentos são o caractere - e o endereço UNIX-CONNECT:....O primeiro lado (-): No Linux, o caractere - representa a Entrada Padrão (stdin). Ele diz ao socat: "Fique escutando tudo o que for enviado para você através do pipe (|)". Como usamos o echo "system_powerdown" |, o socat recebe esse texto de texto puro.O segundo lado (UNIX-CONNECT:/tmp/...sock): Esse argumento diz ao socat: "Abra uma conexão de dados do tipo Socket Unix usando o arquivo que está em /tmp/windows-server-vm.sock".
# Quando a sua VM ligou, o argumento do QEMU (-monitor unix:/tmp/windows-server-vm.sock,server,nowait) criou esse arquivo de socket e ficou "escutando" ele.