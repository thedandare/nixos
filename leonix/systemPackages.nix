# {
#   pkgs,
#   erosanix,
#   ...
# }:
# {
#
#   environment.systemPackages = with pkgs; [
#     # 🪢 Serial TTY
#     screen
#     tio # https://github.com/tio/tio Connect to TTY device directly or via profile or topology ID.
#     bootterm # https://github.com/wtarreau/bootterm A simple, reliable and powerful terminal
#
#     # 🪒 Hardware
#     cpu-x
#     zenstates
#     zenmonitor
#     libsigrok # https://github.com/sipeed/libsigrok/
#     sigrok-cli # Signal analysis software suite
#     toybox # Programs provided:
#     # [ acpi arch ascii base32 base64 basename blkdiscard blkid blockdev bunzip2 bzcat cal cat
#     # chattr chgrp chmod chown chroot chrt chvt cksum clear cmp comm
#     # count cp cpio crc32 cut date dd deallocvt devmem df dirname dmesg dnsdomainname
#     # dos2unix du echo egrep eject env expand factor fallocate false fgrep file find
#     # flock fmt fold free freeramdisk fsfreeze fstype fsync ftpget ftpput getconf getopt gpiodetect gpiofind gpioget gpioinfo gpioset grep groups gunzip halt
#     # help hexedit host hostname httpd hwclock i2cdetect i2cdump i2cget i2cset i2ctransfer iconv id ifconfig inotifyd insmod install ionice iorenice iotop kill
#     # killall killall5 link linux32 ln logger login logname losetup ls lsattr lsmod lspci lsusb makedevs mcookie md5sum memeater microcom mix mkdir mkfifo mknod
#     # mkpasswd mkswap mktemp modinfo mount mountpoint mv nbd-client nbd-server nc netcat netstat nice nl nohup nologin nproc nsenter od oneit openvt partprobe
#     # patch pgrep pidof ping ping6 pivot_root pkill pmap poweroff printenv printf prlimit ps pwd pwdx pwgen readahead readelf readlink realpath reboot renice
#     # rev rfkill rm rmdir rmmod rtcwake sed seq setfattr setsid sha1sum sha224sum sha256sum sha384sum sha3sum sha512sum shred shuf sleep sntp sort split stat
#     # su swapoff swapon switch_root sync sysctl tac tail tar taskset tee test time timeout top touch toybox true truncate ts tsort tty tunctl uclampset ulimit umount
#     # uname unicode uniq unix2dos unlink unshare uptime usleep uudecode uuencode uuidgen vconfig vmstat w watch watchdog wc wget which who whoami xargs xxd yes zca ]
#     # https://landley.net/toybox/
#     usbutils
#     pciutils # https://mj.ucw.cz/sw/pciutils/
#     /*
#       Including: lspci – a utility for displaying information about PCI buses in the system and devices connected to them.
#       setpci – a utility for querying and poking configuration registers of PCI devices.
#       pcilib – manual on the libpci library and options common to all tools using it.
#       pci.ids – the list of known identifiers related to PCI devices..
#       update-pciids – a utility for downloading a new version of the PCI ID list.
#       pcilmr – a utility for margining PCIe links.
#     */
#
#     # ⚓ NixOS configuration
#     nixos-grub2-theme
#
#     nixfmt
#     nixos-artwork.wallpapers.binary-red
#     # TODO agenix:>    inputs.agenix.packages."${system}".default
#
#     # 🔊 Audio
#     asha-pipewire-sink # Pairing hearing aids using the ASHA protocol
#     pavucontrol
#     ncpamixer
#     pipewire
#     qjackctl
#     qpwgraph # Graph manager dedicated for PipeWire, using the Qt C++ framework, based and pretty much like the same of QjackCtl.
#     easyeffects # https://github.com/wwmm/easyeffects
#     cava # https://github.com/karlstav/cava
#     cavasik # Audio visualizer based on CAVA with extended capabilities
#
#     # 👶 Boot / partitioning
#     efibooteditor
#     refind
#     efivar # https://github.com/rhboot/efivar
#     goldboot # https://github.com/fossable/goldboot
#     btrfs-progs
#     gparted-full
#     grub2_efi
#     uefitool # https://github.com/LongSoft/uefitool
#
#     # 🧹 Cleanup
#     bleachbit
#     nix-janitor
#
#     # 📀 Drivers
#     ckb-next # 🖱️ Corsair mouse configuration tool
#
#     # 🥸 Desktop
#     kdePackages.ksshaskpass # Ferramenta nativa do KDE para senhas
#     lockbook-desktop
#     #     mouse-actions-gui # [https://github.com/jersou/mouse-actions]
#     zsnes
#
#     ## Image Editor
#     pixieditor
#
#     # 👩‍💻 Development
#     ## IDEs
#     antigravity
#     windsurf
#     jetbrains.idea
#     jetbrains.pycharm
#     ## Runbooks
#     atuin-desktop
#     ## SDKs / envs
#     dart
#     flutter341
#     uv
#     nodejs_24
#     plantuml-server
#
#     # Google
#     androidsdk
#     google-chrome
#     google-fonts
#     google-cloud-sdk
#     google-cloud-sdk-gce
#     google-compute-engine
#     ungoogled-chromium
#
#     # Hypervisors
#     photoprism
#     virt-manager
#     socat # http://www.dest-unreach.org/socat/ Utility for bidirectional data transfer between two independent data channels
#     websocat # https://github.com/vi/websocat
#     qemu
#     quickemu
#     qemu-utils
#     uefi-run
#     virt-viewer
#     spice-gtk
#     spice
#     vhost-device-sound
#
#     # 🎱 Kubernets
#     kubectl
#     kubectl-ai
#     kompose
#     opentofu
#     stern # Multi pod and container log tailing for Kubernetes Usage stern pod-query [flags] https://github.com/stern/stern
#     k9s
#
#     # 📺 Media
#     vlc
#
#     # 👀 Monitoring
#
#     # 📡 Networking
#     tailscale
#     nmap
#     zenmap
#     whosthere
#     net-tools
#     tunctl
#     lan-mouse
#     tshark
#     wireshark
#     wireshark-cli
#
#     # 🏢 Remote Access
#     x2goclient
#     gnome-connections
#     x2goserver
#     remmina
#     freerdp
#     #     turbovnc
#     tigervnc
#
#     # 🌏 Sharing
#     rqbit
#
#     # 📻 SDR
#     gnuradio
#     gnuradioPackages.osmosdr # Programs provided
#     # gnuradio-config-info gnuradio-companion gr-ctrlport-monitor gr-perf-monitorx gr_filter_design gr_modtool gr_plot gr_plot_const gr_plot_fft gr_plot_iq
#     # gr_plot_psd gr_plot_qt gr_read_file_metadata grcc polar_channel_construction uhd_fft uhd_rx_cfile uhd_rx_nogui uhd_siggen uhd_siggen_gui
#     # rtl-sdr
#     # rtl-sdr-blog # Software to turn the RTL2832U into a SDR receiver
#     rtl-sdr-librtlsdr # Fork of the rtl-sdr library by the Osmocom project.
#     # Programs provided
#
#     # rtl_sdr rtl_adsb rtl_biast rtl_eeprom rtl_fm rtl_ir rtl_power rtl_raw2wav
#     # rtl_rpcd rtl_tcp rtl_test rtl_udp rtl_wavestat rtl_wavestream
#     sdr-j-fm
#
#     # 🐚 Terminals
#     alacritty
#     alacritty-graphics
#     pycritty # CLI tool for changing your alacritty configuration on the fly
#
#     cool-retro-term
#     fzf
#     wezterm
#     vimPlugins.wezterm-nvim
#
#     # 📧 Text editors
#     gnvim # https://github.com/vhakulinen/gnvim
#     glrnvim # https://github.com/beeender/glrnvim
#     leo-editor # https://leo-editor.github.io/leo-editor/
#
#     # Themes
#     chicago95
#     darkly
#
#     # TUIs /
#     msedit
#     notcurses
#     tuios # https://tuios.gaurav.
#     wiremix # TUI audio mixer for PipeWire.
#     tparted
#     fortune
#     newt
#     dmenu
#     fastfetch # tool for fetching system information, written mainly in C [https://github.com/fastfetch-cli/fastfetch]
#     zigfetch # Minimal neofetch/fastfetch like system information tool [https://github.com/utox39/zigfetch]
#     termshark # Terminal UI for tshark
#
#     # ⛽ Util
#     wget
#     jq
#     wiper
#     dysk
#     zenith
#     unrar-free
#
#     # ❎ X-Win
#     xauth
#     xinit
#     anyrun # Wayland-native, highly customizable runner
#     wayland-utils # Wayland diagnostic tools
#     wl-clipboard # Wayland copy/paste support
#     vulkan-tools
#     libxdmcp
#     gpu-viewer
#     xclip # X clipboard for console application  Programs also provided:
#     # xclip-copyfile
#     # xclip-cutfile
#     # xclip-pastefile
#
#     # 🪟 Windows
#     wineWow64Packages.full
#     winetricks
#     q4wine
#
#     kiwix
#     kiwix-tools
#     vue # Visual Understanding Environment | teaching and presentation tool. https://github.com/VUE/VUE
#     z-library-desktop
#     ayugram-desktop # Desktop Telegram client with good customization and Ghost mode
#
#     #     runbooks
#
#     #   Movidos para programs.neovim:
#     #     vimPlugins.ChatGPT-nvim
#     #     vimPlugins.moveline-nvim
#     #     vimPlugins.GPTModels-nvim # https://github.com/Aaronik/GPTModels.nvim/
#     #     vimPlugins.dart-vim-plugin # https://github.com/dart-lang/dart-vim-plugin/
#     #     vimPlugins.conform-nvim # Formatter plugin for Neovim https://github.com/stevearc/conform.nvim/
#
#     agneyastra # A firebase Misconfiguration Detection Toolkit [https://github.com/JA3G3R/agneyastra]
#
#     rpi-imager # Raspberry Pi Imaging Utility
#
#     #     (
#     #       let
#     #         inputs = builtins.getFlake "ubuntu/flakes/inputactions";
#     #       in
#     #       inputs.inputactions-ctl.packages.${system}.default
#     #         inputs.inputactions-standalone.packages.${system}.default
#     #     )
#
#     # Local Flakes
#     ## Testing / Templates
#     #     (
#     #       let
#     #         myflake = builtins.getFlake "/home/leo/myflake";
#     #       in
#     #       myflake.packages.${system}.default
#     #     )
#
#     #     (
#     #       let
#     #         myflake = builtins.getFlake "/home/leo/myflake";
#     #       in
#     #       myflake.packages.${system}.hello
#     #     )
#
#     # 1. Foo
#     #     (
#     #       let
#     #         fooFlake = builtins.getFlake "/home/leo/flakes/foo"; # Ajuste o caminho se estiver em uma subpasta (ex: "/home/leo/flakes/foo")
#     #       in
#     #       fooFlake.packages.${system}.foo
#     #     )
#     #
#     #     ## Desktop / Devices
#     #     # 2. Corsair Mouse
#     #     (
#     #       let
#     #         corsairFlake = builtins.getFlake "/home/leo/flakes/initCorsairMouse";
#     #       in
#     #       corsairFlake.packages.${system}.initCorsairMouse
#     #     )
#     #
#     #     ## Development
#     #     # 3. Copy Source Code (Note que faltava ".packages" no seu erro original, adicionei aqui para corrigir)
#     #     (
#     #       let
#     #         ramdiskFlake = builtins.getFlake "/home/leo/flakes/copySourceCodeToRamdisk";
#     #       in
#     #       ramdiskFlake.packages.${system}.copySourceCodeToRamdisk
#     #     )
#     #
#     #     # 4. Fibo Serverpod
#     #     (
#     #       let
#     #         fiboFlake = builtins.getFlake "/home/leo/flakes/fibo-serverpod";
#     #       in
#     #       fiboFlake.packages.${system}.fibo-serverpod
#     #     )
#     #
#     #     # 5. Foobar2000
#     #     (
#     #       let
#     #         foobarFlake = builtins.getFlake "/home/leo/flakes/foobar2000";
#     #       in
#     #       foobarFlake.packages.${system}.foobar2000
#     #     )
#
#     lxc
#
#   ];
# }