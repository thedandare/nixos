rec {

  HOME = "/home/leo/emulators/";
  OVFM_BIOS = "${HOME}/OVMF_CODE_4M.fd";
  EFI_DRIVE = "-drive if=pflash,format=raw,readonly=on,file=${OVFM_BIOS}";
  #   WIN_SRV_CDROM = "-cdrom /opt/iso/Windows_InsiderPreview_Server_vNext_en-us_29595.iso";
  WIN_SRV_CDROM = "-cdrom  /opt/iso/rescue/HBCD_PE_x64.iso";
  UBUNTU_CDROM = "-cdrom /opt/iso/kubuntu-26.04-desktop-amd64.iso";
  WIN_VIRTIO_CDROM = "-drive file=/opt/iso/virtio-win-0.1.285.iso,media=cdrom,if=none,id=virtio_cd -device ide-cd,drive=virtio_cd,bus=ahci0,unit=5";

  BRIDGE_IFACE = "br0";
  MACHINE = " -machine q35,accel=kvm -cpu host,migratable=off,+topoext ";
  #   -machine
  #   Sim, o Q35 é o chipset virtual mais avançado e moderno para arquiteturas de computador padrão x86_64 no QEMU. Ele substituiu o antigo modelo i440FX (que simula uma placa-mãe de 1996) e tornou-se a escolha padrão recomendada para quase todos os sistemas operacionais modernos.A grande diferença é que o i440FX é baseado no barramento PCI legado, enquanto o Q35 implementa o barramento PCI Express (PCIe) nativo.
  # the CPU hierarchy must match maxcpus: sockets (1) * dies (1) * modules (1) * cores (8) * threads (4) = maxcpus (16)
  SMP = " -smp cpus=12,sockets=1,dies=1,cores=6,threads=2  "; # Symmetric Multiprocessing
  /*
      A arquitetura do Ryzen 3900 é dividida em 2 Chiplets (CCDs), e cada chiplet tem 2 complexos de núcleos (CCX) de 3 núcleos cada. Para o QEMU extrair o máximo de performance (especialmente em jogos e renderização), a topologia virtual deve respeitar a topologia real do processador.
          -cpu host,migratable=off,+topoext \
          -smp cpus=12,sockets=1,dies=1,cores=6,threads=2
              +topoext: Ativa as extensões de topologia da AMD. Isso faz com que a VM entenda exatamente que está rodando em um processador Ryzen, otimizando o uso do cache L3.
              migratable=off: Garante que todas as features específicas do seu Ryzen 3900 sejam passadas para a VM sem restrições.
  */

  /*
       Ryzens sofrem penalidade de performance se a VM ficar paginando memória em blocos pequenos (4KB). Usar Hugepages de 2MB muda o jogo.
          -m 8G -object memory-backend-ram,id=mem0,size=8

          Tamanho das páginas: O padrão da arquitetura x86_64 é alocar páginas de 2MB. Se você estiver configurando hugepages para cenários de alto desempenho muito específicos (como o emulador de CPU/GPU em máquinas virtuais via VFIO ou bancos de dados como Oracle), você pode definir explicitamente o tamanho padrão adicionando "default_hugepagesz=2M" "hugepagesz=2M" j

      Latência zero: deve travar as threads da VM nos núcleos físicos corretos do Ryzen 3900, idealmente mantendo-os dentro do mesmo CCX para evitar que os dados fiquem pulando de um chiplet para o outro. No QEMU puro, isso é feito via ferramentas como taskset.
  */
  # --- Configurações dos Discos Físicos (Host) ---
  PASSTHROUGH_WD40 = "/dev/disk/by-id/ata-WDC_WD40PURZ-85TTDY0_WD-WCC7K2ZF3NT1";
  PASSTHROUGH_ST40 = "/dev/disk/by-id/ata-ST4000VX016-3CV104_WW60QZE2";
  PASSTHROUGH_ST10 = "/dev/disk/by-id/ata-ST1000DM010-2EP102_ZN1LPA8P";

  # --- Variáveis Compartilhadas de Performance ---
  # Define o comportamento padrão do QEMU para acesso direto ao bloco físico sem cache do host
  DRIVE_OPTS = "format=raw,if=none,cache=none,aio=native,discard=on";

  # =========================================================================
  # OPÇÃO 1 (ATUAL): Emulação AHCI/SATA Clássica (Lenta, mas compatibilidade nativa)
  # =========================================================================
  #   PASS_WD40 = "-drive file=${PASSTHROUGH_WD40},format=raw,if=none,id=physical_ata1,cache=none -device ide-hd,drive=physical_ata1,bus=ahci0.1";
  #   PASS_ST40 = "-drive file=${PASSTHROUGH_ST40},format=raw,if=none,id=physical_ata2,cache=none -device ide-hd,drive=physical_ata2,bus=ahci0.2";
  #   PASS_ST10 = "-drive file=${PASSTHROUGH_ST10},format=raw,if=none,id=physical_ata3,cache=none -device ide-hd,drive=physical_ata3,bus=ahci0.3";

  # =========================================================================
  # OPÇÃO 2: VirtIO Block PCI (Máxima performance por disco individual)
  # Requer driver 'viostor' no instalador do Windows. Ubuntu nativo.
  # =========================================================================
  PASS_WD40 = "-drive file=${PASSTHROUGH_WD40},${DRIVE_OPTS},id=virtio_drive1 -device virtio-blk-pci,drive=virtio_drive1,id=wd40_blk";
  PASS_ST40 = "-drive file=${PASSTHROUGH_ST40},${DRIVE_OPTS},id=virtio_drive2 -device virtio-blk-pci,drive=virtio_drive2,id=st40_blk";
  PASS_ST10 = "-drive file=${PASSTHROUGH_ST10},${DRIVE_OPTS},id=virtio_drive3 -device virtio-blk-pci,drive=virtio_drive3,id=st10_blk";

  # =========================================================================
  # OPÇÃO 3: VirtIO SCSI (Melhor para gerenciar múltiplos discos juntos)
  # Requer driver 'vioscsi' no instalador do Windows. Ubuntu nativo.
  # NOTA: Se usar esta opção, adicione a variável ${constantes.SCSI_CONTROLLER} no seu COMANDO de boot.
  # =========================================================================
  /*
    SCSI_CONTROLLER = "-device virtio-scsi-pci,id=scsibus0";
    PASS_WD40       = "-drive file=${PASSTHROUGH_WD40},${DRIVE_OPTS},id=scsi_drive1 -device scsi-hd,drive=scsi_drive1,bus=scsibus0.0,lun=1";
    PASS_ST40       = "-drive file=${PASSTHROUGH_ST40},${DRIVE_OPTS},id=scsi_drive2 -device scsi-hd,drive=scsi_drive2,bus=scsibus0.0,lun=2";
    PASS_ST10       = "-drive file=${PASSTHROUGH_ST10},${DRIVE_OPTS},id=scsi_drive3 -device scsi-hd,drive=scsi_drive3,bus=scsibus0.0,lun=3";
  */
}
