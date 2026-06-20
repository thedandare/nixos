#!/usr/bin/env bash
set -euo pipefail

# Create packages target folder
mkdir -p ./packages

# 1. Sys & Hardware
cat << 'EOF' > ./packages/sys-hardware.nix
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
EOF

# 2. Development & DevOps
cat << 'EOF' > ./packages/development.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 👩‍💻 Development
    ## IDEs
    antigravity
    windsurf
    jetbrains.idea
    jetbrains.pycharm
    ## Runbooks
    atuin-desktop
    ## SDKs / envs
    dart
    flutter341
    uv
    nodejs_24
    plantuml-server

    # Google
    androidsdk
    google-cloud-sdk
    google-cloud-sdk-gce
    google-compute-engine

    # Hypervisors
    photoprism
    virt-manager
    socat # http://www.dest-unreach.org/socat/ Utility for bidirectional data transfer between two independent data channels
    websocat # https://github.com/vi/websocat
    qemu
    quickemu
    qemu-utils
    uefi-run
    virt-viewer
    spice-gtk
    spice
    vhost-device-sound

    # 🎱 Kubernets
    kubectl
    kubectl-ai
    kompose
    opentofu
    stern # Multi pod and container log tailing for Kubernetes Usage stern pod-query [flags] https://github.com/stern/stern
    k9s

    agneyastra # A firebase Misconfiguration Detection Toolkit [https://github.com/JA3G3R/agneyastra]
  ];
}
EOF

# 3. Networking & SDR
cat << 'EOF' > ./packages/networking.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 📡 Networking
    tailscale
    nmap
    zenmap
    whosthere
    net-tools
    tunctl
    lan-mouse
    tshark
    wireshark
    wireshark-cli

    # 🏢 Remote Access
    x2goclient
    gnome-connections
    x2goserver
    remmina
    freerdp
    tigervnc

    # 🌏 Sharing
    rqbit

    # 📻 SDR
    gnuradio
    gnuradioPackages.osmosdr # Programs provided
    rtl-sdr-librtlsdr # Fork of the rtl-sdr library by the Osmocom project.
    sdr-j-fm
  ];
}
EOF

# 4. Media & Desktop Environment
cat << 'EOF' > ./packages/media-desktop.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 🔊 Audio
    asha-pipewire-sink # Pairing hearing aids using the ASHA protocol
    pavucontrol
    ncpamixer
    pipewire
    qjackctl
    qpwgraph # Graph manager dedicated for PipeWire, using the Qt C++ framework, based and pretty much like the same of QjackCtl.
    easyeffects # https://github.com/wwmm/easyeffects
    cava # https://github.com/karlstav/cava
    cavasik # Audio visualizer based on CAVA with extended capabilities

    # 🥸 Desktop
    kdePackages.ksshaskpass # Ferramenta nativa do KDE para senhas
    lockbook-desktop
    zsnes

    ## Image Editor
    pixieditor

    # Google Apps
    google-chrome
    google-fonts
    ungoogled-chromium

    # 📺 Media
    vlc

    # Themes
    chicago95
    darkly

    # 🪟 Windows
    wineWow64Packages.full
    winetricks
    q4wine

    # Apps / Education
    kiwix
    kiwix-tools
    vue # Visual Understanding Environment | teaching and presentation tool. https://github.com/VUE/VUE
    z-library-desktop
    ayugram-desktop # Desktop Telegram client with good customization and Ghost mode
  ];
}
EOF

# 5. Terminals & Core Utilities
cat << 'EOF' > ./packages/terminal-utils.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 🐚 Terminals
    alacritty
    alacritty-graphics
    pycritty # CLI tool for changing your alacritty configuration on the fly
    cool-retro-term
    fzf
    wezterm
    vimPlugins.wezterm-nvim

    # 📧 Text editors
    gnvim # https://github.com/vhakulinen/gnvim
    glrnvim # https://github.com/beeender/glrnvim
    leo-editor # https://leo-editor.github.io/leo-editor/

    # TUIs /
    msedit
    notcurses
    tuios # https://tuios.gaurav.
    wiremix # TUI audio mixer for PipeWire.
    tparted
    fortune
    newt
    dmenu
    fastfetch # tool for fetching system information, written mainly in C [https://github.com/fastfetch-cli/fastfetch]
    zigfetch # Minimal neofetch/fastfetch like system information tool [https://github.com/utox39/zigfetch]
    termshark # Terminal UI for tshark

    # ⛽ Util
    wget
    jq
    wiper
    dysk
    zenith
    unrar-free

    # ❎ X-Win
    xauth
    xinit
    anyrun # Wayland-native, highly customizable runner
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support
    vulkan-tools
    libxdmcp
    gpu-viewer
    xclip # X clipboard for console application  Programs also provided:
  ];
}
EOF

# 6. Base / Core Layout
cat << 'EOF' > ./packages/base.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # ⚓ NixOS configuration
    nixos-grub2-theme
    nixfmt
    nixos-artwork.wallpapers.binary-red
  ];
}
EOF

echo "All package files generated successfully within the './packages' folder!"
