{
  pkgs,
  ...
}:
{
  home-manager.users.leo.home.packages = with pkgs; [
    # 🪚 Configuration
    chezmoi # Manage your dotfiles across multiple machines, securely https://www.chezmoi.io

    # 🔍 Search and Destroy
    kdePackages.kfind

    kdePackages.bluedevil
    kdePackages.calendarsupport
    kdePackages.drumstick
    kdePackages.dynamic-workspaces
    kdePackages.k3b
    kdePackages.kdeedu-data
    kdePackages.kcolorpicker
    kdePackages.kcolorchooser
    kdePackages.kgraphviewer
    kdePackages.kgeography
    gravit # visually stunning gravity simulator, https://github.com/gak/gravit

    atool # Manage file archives of various types.

    httpie # (pronounced aitch-tee-tee-pie)
    # is a command-line HTTP client. Its goal is to make CLI interaction with web services as human-friendly as possible. HTTPie is designed for testing, debugging, and generally interacting with APIs & HTTP servers. The http & https commands allow for creating and sending arbitrary HTTP requests. They use simple and natural syntax and provide formatted and colorized output.
    httpie-desktop

    #     googleearth-pro

    lockbook-desktop

    # 🎳 Gaming
    #         rpcs3 # PS3 emulator/debugger
    zsnes
    #     retroarch-full
    #     retroarch-bare
    #     retroarch-joypad-autoconfig
    #     retroarch-assets

    # ⏬ Downloading
    yt-dlp # yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.
    media-downloader # front end to yt-dlp, youtube-dl, gallery-dl, lux, you-get, svtplay-dl, aria2c, wget and safari books.
    lux # Fast and simple video download library and CLI tool written in Go [https://github.com/iawia002/lux]
    aria2 # Lightweight, multi-protocol, multi-source, command-line download utility [https://aria2.github.io/]

    # 📻 Multimedia
    plex-desktop
    plexamp
    # Ferramentas de linha de comando para manipular os arquivos baixados
    abcm2ps # Converte o arquivo .abc em arquivos de imagem/PDF com a partitura gráfica real
    abcmidi # Transforma o arquivo de texto bruto em um arquivo de áudio .mid executável
    easyabc # [https://easyabc.sourceforge.net/]
    # Reprodutor de áudio MIDI leve para escutar os resultados no terminal
    timidity
    # KDE Customization
    kdePackages.karousel

    # KDE tools
    kdePackages.kbookmarks # [http://invent.kde.org/frameworks/kbookmarks] manipulate bookmarks using XBEL (https://pyxml.sourceforge.net/topics/xbel/) format.
    kdePackages.kde-cli-tools # [https://invent.kde.org/plasma/kde-cli-tools]  a core software package provided by the KDE Community that bundles essential CLI utilities.
    #                 These tools bridge the gap between the terminal and the graphical env., allowing you to trigger actions, modify file assoc, and manage KDE.
    #   🪛 kde-open: Opens any file or URL using the user's preferred default application configured in Plasma.
    #   🪛 kioclient: A cmd net assist that interacts  with KDE’s network transparency layer (KIO slaves),
    #        allowing you to copy, move, or make directories over protocols like FTP, SFTP, and SMB.
    #   🪛 keditfiletype: Modifies file type associations and MIME type assignments from the command line.
    #   🪛 kmimetypefinder: Detects the precise MIME type of a sxpecified file or layout.
    #   🪛 kde-inhibit: Prevents the system from sleeping, locking, or dimming the screen while a specific command runs.
    #   🪛 kstart: Launches graphical applications with specific structural commands, such as forcing them to open
    #        full screen, iconified, or on a specific virtual desktop.
    #   🪛 kinfo: Fetches centralized hardware and software system overview details  from the command line.
    #   🪛 kbroadcastnotification: Triggers standard Plasma system desktop notifications programmatically.
    #   🪛 plasma-open-settings: Commands the desktop environment to directly open specific modules inside System Settings.
  ];
}
