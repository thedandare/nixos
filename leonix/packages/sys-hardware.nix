{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 🪢 Serial TTY
    screen
    tio # https://github.com/tio/tio Connect to TTY device directly or via profile or topology ID.
    bootterm # https://github.com/wtarreau/bootterm A simple, reliable and powerful terminal

    # 🪒 Hardware
    cpu-x
    zenstates
    zenmonitor
    libsigrok # https://github.com/sipeed/libsigrok/
    sigrok-cli # Signal analysis software suite
    toybox
    usbutils
    pciutils # https://mj.ucw.cz/sw/pciutils/
    /*
      Including: lspci – a utility for displaying information about PCI buses in the system and devices connected to them.
      setpci – a utility for querying and poking configuration registers of PCI devices.
      pcilib – manual on the libpci library and options common to all tools using it.
      pci.ids – the list of known identifiers related to PCI devices..
      update-pciids – a utility for downloading a new version of the PCI ID list.
      pcilmr – a utility for margining PCIe links.
    */

    # 👶 Boot / partitioning
    efibooteditor
    refind
    efivar # https://github.com/rhboot/efivar
    goldboot # https://github.com/fossable/goldboot
    btrfs-progs
    gparted-full
    grub2_efi
    uefitool # https://github.com/LongSoft/uefitool

    # 🧹 Cleanup
    bleachbit
    nix-janitor

    # 📀 Drivers
    ckb-next # 🖱️ Corsair mouse configuration tool

    rpi-imager # Raspberry Pi Imaging Utility
  ];
}
