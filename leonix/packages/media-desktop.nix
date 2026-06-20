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
