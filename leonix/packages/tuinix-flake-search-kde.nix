{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix search flake: kde
    # [0;1mlegacyPackages.x86_64-linux.adapta-[32;1mkde[0;1m-theme[0m # Port of the Adapta theme for Plasma
    # [0;1mlegacyPackages.x86_64-linux.alkimia[0m # Library used by [32;1mKDE[0m finance applications
    # [0;1mlegacyPackages.x86_64-linux.application-title-bar[0m # [32;1mKDE[0m Plasma6 widget with window controls
    # [0;1mlegacyPackages.x86_64-linux.arc-[32;1mkde[0;1m-theme[0m # Port of the arc theme for Plasma
    # [0;1mlegacyPackages.x86_64-linux.asn2quic[32;1mkde[0;1mr[0m # ASN.1 compiler with a backend for Quick DER
    # [0;1mlegacyPackages.x86_64-linux.capitaine-cursors[0m # X-cursor theme inspired by macOS and based on [32;1mKDE[0m Breeze
    # [0;1mlegacyPackages.x86_64-linux.catppuccin-[32;1mkde[0;1m[0m # Soothing pastel theme for [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.colorfuldarkglobal6-[32;1mkde[0;1m[0m # Port of the Colorful-Dark-Global-6 theme for Plasma
    # [0;1mlegacyPackages.x86_64-linux.darwin.dis[32;1mkde[0;1mv_cmds[0m # Disk commands for Darwin
    # [0;1mlegacyPackages.x86_64-linux.fokus[0m # Simple pomodoro [32;1mKDE[0m Plasma plasmoid
    # [0;1mlegacyPackages.x86_64-linux.gnomeExtensions.dash-to-panel[0m # An icon taskbar for the Gnome Shell. This extension moves the dash into the gnome main panel so that the application launchers and system tray are combined into a single panel, similar to that found in [32;1mKDE[0m Plasma and Windows 7+. A separate dock is no longer needed for easy access to running and favorited applications.
    # [0;1mlegacyPackages.x86_64-linux.gnomeExtensions.gsconnect[0m # [32;1mKDE[0m Connect implementation for Gnome Shell
    # [0;1mlegacyPackages.x86_64-linux.gnomeExtensions.hidden-input-method-panel[0m # Hidden input method panel using [32;1mKDE[0m's kimpanel protocol for Gnome-Shell
    # [0;1mlegacyPackages.x86_64-linux.gnomeExtensions.kimpanel[0m # Input Method Panel using [32;1mKDE[0m's kimpanel protocol for Gnome-Shell
    # [0;1mlegacyPackages.x86_64-linux.gnomeExtensions.modern-clock[0m # [32;1mKDE[0m Modern Clock style widget for GNOME. Inspired by Prayag2's [32;1mkde[0m_modernclock.
    # [0;1mlegacyPackages.x86_64-linux.haskellPackages.autonix-deps-kf5[0m # Generate dependencies for [32;1mKDE[0m 5 Nix expressions
    # [0;1mlegacyPackages.x86_64-linux.haskellPackages.has[32;1mkde[0;1mep[0m # Computes and audits file hashes
    # [0;1mlegacyPackages.x86_64-linux.haskellPackages.[32;1mkde[0;1msrc-build-extra[0m # Build profiles for [32;1mkde[0msrc-build
    # [0;1mlegacyPackages.x86_64-linux.haskellPackages.[32;1mkde[0;1msrc-build-profiles[0m # Build profiles for [32;1mkde[0msrc-build
    # [0;1mlegacyPackages.x86_64-linux.haskellPackages.pac[32;1mkde[0;1mps[0m # Check your cabal packages for lagging dependencies
    # [0;1mlegacyPackages.x86_64-linux.kara[0m # [32;1mKDE[0m Plasma Applet for use as a desktop/workspace pager
    # [0;1mlegacyPackages.x86_64-linux.karp[0m # [32;1mKDE[0m alternative to PDF arranger
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1m-gruvbox[0m # Suite of themes for [32;1mKDE[0m applications that match the retro gruvbox colorscheme
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1m-rounded-corners[0m # Rounds the corners of your windows
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.accessibility-inspector[0m # Inspect your application accessibility tree
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.accounts-qt[0m # Qt library for accessing the online accounts database
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi[0m # Cross-desktop storage service for PIM data providing concurrent access
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-calendar[0m # Akonadi calendar integration
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-calendar-tools[0m # Console applications and utilities for managing calendars in Akonadi
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-contacts[0m # Libraries and daemons to implement Contact Management in Akonadi
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-import-wizard[0m # Assistant to import external PIM data into Akonadi for use in [32;1mKDE[0m PIM apps
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-mime[0m # Helpers to make working with emails through Akonadi easier
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadi-search[0m # Libraries and daemons to implement searching in Akonadi
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akonadiconsole[0m # Application for debugging Akonadi Resources
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.akregator[0m # RSS Feed Reader
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.alligator[0m # Kirigami-based RSS reader
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.alpaka[0m # Kirigami client for Ollama
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.analitza[0m # Library that lets you add mathematical features to your program
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.angelfish[0m # Web browser for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.applet-window-buttons6[0m # Plasma 6 applet in order to show window buttons in your panels
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.appstream-qt[0m # Software metadata handling library - Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.arianna[0m # EPub Reader for mobile devices
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ark[0m # File archiver by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.artikulate[0m # Pronunciation trainer to improve your skills by listening to native speakers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.attica[0m # Attica is a Qt library that implements the Open Collaboration Services API.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.audex[0m # Tool for ripping compact discs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.audiocd-kio[0m # KIO worker for accessing audio CDs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.audiotube[0m # Client for YouTube Music
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.aurorae[0m # Aurorae is a themeable window decoration for KWin
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.baloo[0m # Baloo is a framework for searching and managing metadata.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.baloo-widgets[0m # Widgets for Baloo
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.blinken[0m # Memory Enhancement Game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.bluedevil[0m # Bluedevil adds Bluetooth capabilities to [32;1mKDE[0m Plasma
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.bluez-qt[0m # Qt wrapper for Bluez 5 DBus API
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.bomber[0m # Bomber is a single player arcade game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.bovo[0m # Bovo is a Gomoku like game for two players
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.breeze[0m # Artwork, styles and assets for the Breeze visual style for the Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.breeze-grub[0m # GRUB theme for the Breeze visual style for the Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.breeze-gtk[0m # Breeze widget theme for GTK 2 and 3
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.breeze-icons[0m # Breeze icon theme.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.breeze-plymouth[0m # Plymouth theme for the Breeze visual style for the Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.calendarsupport[0m # Library that provides calendar support for PIM
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.calindori[0m # Calendar for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.calligra[0m # Office and graphic art suite by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.cantor[0m # Front end to powerful mathematics and statistics packages
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.cmark[0m # CommonMark parsing and rendering library and program in C
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.colord-[32;1mkde[0;1m[0m # Provides interfaces and session daemon to colord
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.discover[0m # Helps you find and install applications, games, and tools
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.dolphin[0m # File manager by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.dolphin-plugins[0m # Plugins for Dolphin
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.dragon[0m # Multimedia player with the focus on simplicity, not features
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.drkonqi[0m # Crash handler for [32;1mKDE[0m software
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.drumstick[0m # MIDI libraries for Qt/C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.dynamic-workspaces[0m # KWin script that automatically adds/removes virtual desktops
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.elisa[0m # Simple music player aiming to provide a nice experience for its users
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.eventviews[0m # Library for displaying and creating events and calendars
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.extra-cmake-modules[0m # Extra modules and scripts for CMake.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.falkon[0m # Cross-platform Qt-based web browser
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-chinese-addons[0m # Addons related to Chinese, including IME previous bundled inside fcitx4
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-configtool[0m # Configuration Tool for Fcitx5
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-qt[0m # Fcitx5 Qt Library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-skk-qt[0m # Input method engine for Fcitx5, which uses libskk as its backend
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-unikey[0m # Unikey engine support for Fcitx5
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.fcitx5-with-addons[0m # Next generation of fcitx
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ffmpegthumbs[0m # FFmpeg-based thumbnail creator for video files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.filelight[0m # Quickly visualize your disk space usage
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.flatpak-kcm[0m # Flatpak Permissions Management KCM
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.frameworkintegration[0m # Framework providing components to allow applications to integrate with a [32;1mKDE[0m Workspace
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.francis[0m # Track your time
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.futuresql[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ghostwriter[0m # Text editor for Markdown
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.glaxnimate[0m # Simple vector animation program.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.granatier[0m # Granatier is a clone of the classic Bomberman game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.grantlee-editor[0m # Utilities and tools to manage themes in [32;1mKDE[0m PIM applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.grantleetheme[0m # Library that provides Grantlee theme support
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.gwenview[0m # Image viewer by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.incidenceeditor[0m # Library that provides calendar incidence editor
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.isoimagewriter[0m # Program to write hybrid ISO files onto USB disks
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.itinerary[0m # Itinerary and boarding pass management application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.juk[0m # Audio jukebox app, supporting collections of MP3, Ogg Vorbis and FLAC audio files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.k3b[0m # Full-featured CD/DVD/Blu-ray burning and ripping application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kaccounts-integration[0m # Online account management system and its Plasma integration components
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kaccounts-providers[0m # Online account providers for the KAccounts system
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kactivitymanagerd[0m # System service to manage user's activities, track the usage patterns etc.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kaddressbook[0m # Address book application to manage your contacts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kajongg[0m # Mah Jongg - the ancient Chinese board game for 4 players
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kalarm[0m # Application to manage alarms and other timer-based alerts on the desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kalgebra[0m # 2D and 3D Graph Calculator
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kalk[0m # Kalk is a powerful cross-platform calculator application built with the [Kirigami framework](https://[32;1mkde[0m.org/products/kirigami/)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kalm[0m # Kalm can teach you different breathing techniques.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kalzium[0m # Periodic Table of Elements
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kamera[0m # [32;1mKDE[0m integration for gphoto2 cameras
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kamoso[0m # Application to take pictures and videos with your webcam
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kanagram[0m # Letter Order Game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kapidox[0m # Frameworks API Documentation Tools
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kapman[0m # Kapman is a clone of the well known game Pac-Man
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kapptemplate[0m # Factory for the easy creation of [32;1mKDE[0m/Qt components and programs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.karchive[0m # Qt addon providing access to numerous types of archives
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.karousel[0m # Scrollable tiling Kwin script
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kasts[0m # Kirigami-based podcast player
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kate[0m # Advanced text editor
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.katomic[0m # Katomic is a fun and educational game built around molecular geometry
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kauth[0m # KAuth
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kbackup[0m # Backup program with an easy-to-use interface
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kblackbox[0m # KBlackBox is a game of hide and seek played on a grid of boxes
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kblocks[0m # KBlocks is the classic falling blocks game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kbookmarks[0m # KBookmarks
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kbounce[0m # KBounce is a single player arcade game with the elements of puzzle
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kbreakout[0m # KBreakOut is a Breakout-like game. Its objective is to destroy as many bricks as possible without losing the ball.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kbruch[0m # Practice Fractions
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcachegrind[0m # GUI to profilers such as Valgrind
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcalc[0m # Calculator offering everything a scientific calculator does, and more
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcalendarcore[0m # KCalendarCore - Library for Interfacing with Calendars
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcalutils[0m # Library to assist working with calendars
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcharselect[0m # Tool to select and copy special characters from all installed fonts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kclock[0m # Clock app for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcmutils[0m # Utilities for interacting with KCModules
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcodecs[0m # KCodecs provide a collection of methods to manipulate strings using various encodings
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcolorchooser[0m # A small utility to select a color
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcolorpicker[0m # Qt based Color Picker with popup menu
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcolorscheme[0m # Classes to read and interact with KColorScheme
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcompletion[0m # KCompletion
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kconfig[0m # KConfig
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kconfigwidgets[0m # Widgets for KConfig
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcontacts[0m # KContacts - Library for working with contact information
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcoreaddons[0m # KCoreAddons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcrash[0m # KCrash
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kcron[0m # Task scheduler by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdav[0m # DAV protocol implementation with KJobs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdbusaddons[0m # KDBusAddons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1m-cli-tools[0m # Tools based on [32;1mKDE[0m Frameworks 5 to better interact with the system
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1m-dev-scripts[0m # Scripts and setting files useful during development of [32;1mKDE[0m software
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1m-dev-utils[0m # Small utilities for developers using [32;1mKDE[0m/Qt libs/frameworks
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1m-gtk-config[0m # Syncs [32;1mKDE[0m settings to GTK applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1m-inotify-survey[0m # Tooling for monitoring inotify limits and informing the user when they have been or about to be reached.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mbugsettings[0m # Application to choose which QLoggingCategory are displayed
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mclarative[0m # [32;1mKDe[0mclarative
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mconnect-[32;1mkde[0;1m[0m # Multi-platform app that allows your devices to communicate
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mcoration[0m # Plugin-based library to create window decorations
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1md[0m # [32;1mKDE[0m Daemon
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1medu-data[0m # Shared icons, artwork and data files for educational applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mgraphics-mobipocket[0m # A collection of plugins to handle mobipocket files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mgraphics-thumbnailers[0m # Thumbnailers for various graphics file formats
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mnetwork-filesharing[0m # Samba file sharing plugin for file properties
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mnlive[0m # Free and open source video editor, based on MLT Framework and [32;1mKDE[0m Frameworks
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mpim-addons[0m # Add-ons for [32;1mKDE[0m PIM apps (KMail, KAddressBook etc.)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mpim-runtime[0m # Akonadi agents and resources
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mplasma-addons[0m # All kind of add-ons to improve your Plasma experience
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1msdk-kio[0m # KIO workers useful for software development
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1msdk-thumbnailers[0m # Plugins for the thumbnailing system
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1msu[0m # [32;1mKDE[0m Su
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mv-php[0m # PHP Language Plugin for [32;1mKDe[0mvelop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mv-python[0m # [32;1mKDe[0mvelop Python language support
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mvelop[0m # Cross-platform IDE for C, C++, Python, QML/JavaScript and PHP
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.[32;1mkde[0;1mvelop-pg-qt[0m # [32;1mKDe[0mvelop Parser Generator, used in the PHP language plugin and others
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdf[0m # Displays available storage devices and information about their usage
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdiagram[0m # Powerful libraries (KChart, KGantt) for creating business diagrams
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdialog[0m # Tool to show nice dialog boxes from shell scripts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdiamond[0m # KDiamond is a single player puzzle game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdnssd[0m # KDNSSD Framework
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdoctools[0m # KDocTools
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdsoap[0m # Qt-based client-side and server-side SOAP component
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kdsoap-ws-discovery-client[0m # Library for finding WS-Discovery devices in the network using Qt5 and KDSoap.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.keditbookmarks[0m # Bookmarks editor
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.keysmith[0m # OTP client for Plasma Mobile and Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kfilemetadata[0m # A library for extracting file metadata
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kfind[0m # File search utility by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kfourinline[0m # KFourInLine is a four-in-a-row game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kgamma[0m # Adjust your monitor's gamma settings
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kgeography[0m # Geography Trainer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kget[0m # Download Manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kglobalaccel[0m # KGlobalAccel
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kglobalacceld[0m # Daemon providing Global Keyboard Shortcut (Accelerator) functionality
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kgoldrunner[0m # KGoldrunner is a game of action and puzzle solving
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kgpg[0m # Simple interface for GnuPG, a powerful encryption utility
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kgraphviewer[0m # GraphViz dot graph viewer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kguiaddons[0m # KGuiAddons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.khangman[0m # A hangman game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.khealthcertificate[0m # Handling of digital vaccination, test and recovery certificates.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.khelpcenter[0m # Software documentation viewer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kholidays[0m # KHolidays: Library to assist determining when holidays occur
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ki18n[0m # Ki18n
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kiconthemes[0m # KIconThemes
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kidentitymanagement[0m # Library to assist in handling user identities
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kidletime[0m # KIdleTime
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kig[0m # Interactive Geometry
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kigo[0m # Kigo is an open-source implementation of the popular Go game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.killbots[0m # Killbots is a simple game of evading killer robots
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kimageannotator[0m # Tool for annotating images
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kimageformats[0m # KImageFormats
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kimagemapeditor[0m # Generator of HTML image maps
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kimap[0m # Library to assist working with IMAP servers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kinfocenter[0m # View information about your computer's hardware
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio[0m # KIO
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-admin[0m # Manage files as administrator using the admin:// KIO protocol.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-extras[0m # Additional components to increase the functionality of KIO
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-extras-kf5[0m # Additional components to increase the functionality of KIO
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-fuse[0m # FUSE Interface for KIO
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-gdrive[0m # KIO Worker to access Google Drive
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kio-zeroconf[0m # KIO worker to discover file systems by DNS-SD (zeroconf)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kirigami[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kirigami-addons[0m # Add-ons for the Kirigami framework
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kirigami-gallery[0m # Kirigami component gallery application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kiriki[0m # Kiriki is an addictive and fun dice game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kitemmodels[0m # KItemModels
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kitemviews[0m # KItemViews
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kiten[0m # Japanese Reference/Study Tool
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kitinerary[0m # Data Model and Extraction System for Travel Reservation information
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kjobwidgets[0m # KJobWidgets
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kjournald[0m # Framework for interacting with systemd-journald
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kjumpingcube[0m # KJumpingCube is a simple tactical game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kldap[0m # Library to assist working with LDAP directories
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kleopatra[0m # Certificate manager and GUI for OpenPGP and CMS cryptography
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.klettres[0m # Learn The Alphabet
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.klevernotes[0m # A note-taking and management application using markdown.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.klickety[0m # Klickety is an adaptation of the Clickomania game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.klines[0m # KLines is a simple but highly addictive, one player game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmag[0m # Screen magnifier
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmahjongg[0m # KMahjongg is a tile matching game for one or two players
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmail[0m # State-of-the-art feature-rich email client that supports many protocols
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmail-account-wizard[0m # Application which assists you with the configuration of accounts in KMail
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmailtransport[0m # Library, KCM and [32;1mKDE[0mD module to manage mail transport
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmbox[0m # Library for working with MBox format files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmenuedit[0m # Menu Editor for Plasma Workspaces
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmime[0m # Library to assist handling MIME data
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmines[0m # KMines is the classic Minesweeper game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmix[0m # Volume control program
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmousetool[0m # Program that clicks the mouse for you
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmouth[0m # Type-and-say front end for speech synthesizers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kmplot[0m # Mathematical Function Plotter
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knavalbattle[0m # Naval Battle is a ship sinking game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knetwalk[0m # KNetWalk: connect all the terminals to the server, in as few turns as possible
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knewstuff[0m # KNewStuff
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knights[0m # Chess board program.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knighttime[0m # Helpers for scheduling the dark-light cycle
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knotifications[0m # KNotifications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.knotifyconfig[0m # KNotifyConfig
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.koi[0m # Scheduling LIGHT/DARK Theme Converter for the [32;1mKDE[0m Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.koko[0m # Image gallery application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kolf[0m # Kolf is a miniature golf game with 2d top-down view
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kollision[0m # Kollision is a simple ball dodging game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kolourpaint[0m # Easy-to-use paint program
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kompare[0m # Graphical File Differences Tool
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kongress[0m # Companion application for conferences
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.konqueror[0m # Web browser and Swiss Army knife for any kind of file management and previewing
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.konquest[0m # Konquest is the [32;1mKDE[0m version of Gnu-Lactic
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.konsole[0m # Terminal emulator by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kontact[0m # Container application to unify several major PIM applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kontactinterface[0m # Support libraries to assist integration with Kontact
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kontrast[0m # Tool to check contrast for colors that allows verifying that your colors are correctly accessible
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.konversation[0m # User-friendly and fully-featured IRC client
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kopeninghours[0m # Library for parsing and evaluating OSM opening hours expressions.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.korganizer[0m # Organizational assistant, providing calendars and other similar functionality
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kosmindoormap[0m # OSM multi-floor indoor map renderer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpackage[0m # This framework lets applications to manage user installable packages of non-binary assets
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kparts[0m # KParts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpat[0m # KPatience offers a selection of solitaire card games
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpeople[0m # A library that provides access to all contacts and the people who hold them
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpimtextedit[0m # Library that provides extended text editor for PIM applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpipewire[0m # Components relating to Flatpak 'pipewire' use in Plasma.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpkpass[0m # Apple Wallet Pass reader
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kplotting[0m # KPlotting
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpmcore[0m # [32;1mKDE[0m Partition Manager core library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpty[0m # KPty
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kpublictransport[0m # Library to assist with accessing public transport timetables and other data
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kqtquickcharts[0m # QtQuick plugin to render beautiful and interactive charts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kquickcharts[0m # A QtQuick plugin providing high-performance charts.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kquickimageedit[0m # Set of QtQuick components providing basic image editing capabilities
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kquickimageeditor[0m # Set of QtQuick components providing basic image editing capabilities
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krdc[0m # Remote Desktop Client
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krdp[0m # Library and examples for creating an RDP server.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krecorder[0m # Audio recorder for Plasma Mobile and other platforms
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kreversi[0m # KReversi is is a simple one player strategy game played against the computer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krfb[0m # Desktop Sharing
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krohnkite[0m # Dynamic Tiling Extension for KWin 6
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kruler[0m # A pixel measuring tool by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.krunner[0m # Framework for providing different actions given a string query.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksanecore[0m # Library providing logic to interface scanners
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kscreen[0m # [32;1mKDE[0m's screen management software
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kscreenlocker[0m # Library and components for secure lock screen architecture
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kservice[0m # KService
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kshisen[0m # Shisen-Sho is a solitaire-like game played using the standard set of Mahjong tiles
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksirk[0m # KsirK is a computerized version of a well known strategy game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksmtp[0m # Job-based library to send email through an SMTP server
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksnakeduel[0m # KSnakeDuel is a simple snake duel game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kspaceduel[0m # KSpaceDuel: each of two possible players controls a satellite spaceship orbiting the sun
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksquares[0m # KSquares is modeled after the well known pen and paper based game of Dots and Boxes
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksshaskpass[0m # ssh-add helper that uses KWallet and KPasswordDialog
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kstatusnotifieritem[0m # Implementation of Status Notifier Items
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksudoku[0m # KSudoku is a logic-based symbol placement puzzle
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksvg[0m # Components for handling SVGs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksystemlog[0m # [32;1mKDE[0m SystemLog Application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ksystemstats[0m # A plugin based system monitoring daemon.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktactilefeedback[0m # Tactile feedback library for Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kteatime[0m # Handy timer for steeping tea
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktextaddons[0m # Various text handling addons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktexteditor[0m # KTextEditor Framework
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktexttemplate[0m # Library to allow application developers to separate the structure of documents from the data they contain.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktextwidgets[0m # KTextWidgets
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktimer[0m # Little tool to execute programs after some time
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktnef[0m # Libraries to work with TNEF Email Attachments
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktorrent[0m # Powerful BitTorrent client
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktouch[0m # Touch Typing Tutor
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktrip[0m # Public Transport Assistance for Mobile Devices
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ktuberling[0m # KTuberling is a simple constructor game suitable for children and adults alike
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kturtle[0m # Educational programming environment that uses TurtleSpeak
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kubrick[0m # Kubrick is based on the famous Rubik's Cube
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kunifiedpush[0m # UnifiedPush client components
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kunitconversion[0m # KUnitConversion
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kup[0m # Backup scheduler for the Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kuserfeedback[0m # Framework for collecting user feedback for apps via telemetry and surveys
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwallet[0m # KWallet: Credential Storage
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwallet-pam[0m # PAM Integration with KWallet - Unlock KWallet when you login
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwalletmanager[0m # Tool to manage the passwords on your system
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwave[0m # Sound editor by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwayland[0m # KWayland provides a Qt-style Client and Server library wrapper for the Wayland libraries.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwayland-integration[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kweather[0m # Weather application for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kweathercore[0m # Library to facilitate retrieval of weather information including forecasts and alerts
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwidgetsaddons[0m # KWidgetsAddons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwin[0m # Easy to use, but flexible, Wayland Compositor
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwin-x11[0m # Easy to use, but flexible, X Window Manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwindowsystem[0m # KWindowSystem
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwordquiz[0m # Flash Card Trainer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kwrited[0m # Listen to traditional system notifications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kxmlgui[0m # KXMLGUI
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.kzones[0m # [32;1mKDE[0m KWin Script for snapping windows into zones
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.layer-shell-qt[0m # Qt component to allow applications to make use of the Wayland wl-layer-shell protocol.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libgravatar[0m # Library that provides Gravatar support
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libiodata[0m # Library for reading and writing simple structured data
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkcddb[0m # Library used to retrieve audio CD metadata from the Internet
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkdcraw[0m # C++ interface around LibRaw library used to decode RAW picture files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.lib[32;1mkde[0;1mgames[0m # Common code and data for many [32;1mKDE[0m games
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.lib[32;1mkde[0;1mpim[0m # Library for common [32;1mKDE[0m PIM applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkeduvocdocument[0m # Library to parse, convert, and manipulate KVTML files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkexiv2[0m # Wrapper around Exiv2 library to manipulate picture metadata as EXIF and XMP
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkgapi[0m # Library for accessing various Google services via their public API
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkleo[0m # Library that provides cryptography support for mails
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkmahjongg[0m # Common code, backgrounds and tile sets for games using Mahjongg tiles
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkomparediff2[0m # Library to compare files and strings, used in Kompare and [32;1mKDe[0mvelop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libksane[0m # Library providing QWidget with all the logic to interface scanners
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libkscreen[0m # [32;1mKDE[0m's screen management software
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libksieve[0m # Library which manages Sieve support
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libksysguard[0m # Library to retrieve information on the current status of computer hardware
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libktorrent[0m # BitTorrent protocol implementation
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libplasma[0m # Plasma library and runtime components
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libqaccessibilityclient[0m # Accessibilty tools helper library, used e.g. by screen readers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libqglviewer[0m # C++ library based on Qt that eases the creation of OpenGL 3D viewers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libqtdbusmock[0m # Library for mocking DBus interactions using Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libqtdbustest[0m # Library for testing DBus interactions using Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libqtpas[0m # Free Pascal Qt6 binding library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.libquotient[0m # Qt5/Qt6 library to write cross-platform clients for Matrix
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.lokalize[0m # Computer-aided translation
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.lskat[0m # Lieutenant Skat (from German Offiziersskat) is a fun and engaging card game for two players
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mailcommon[0m # Library which provides support for mail applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mailimporter[0m # Library that implements importing of emails from various other email clients
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.maplibre-native-qt[0m # MapLibre Native Qt Bindings and Qt Location Plugin
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.marble[0m # Virtual Globe and World Atlas that you can use to learn more about the Earth
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.markdownpart[0m # KPart for rendering Markdown content
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.marknote[0m # A simple markdown note management app
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.massif-visualizer[0m # Visualizer for Valgrind Massif data files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mbox-importer[0m # Wizard to assist with importing MBox email archives into Akonadi
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.merkuro[0m # Merkuro is a application suite designed to make handling your emails, calendars, contacts, and tasks simple.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.messagelib[0m # Library components for messages (e.g. displaying Akonadi collections)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.milou[0m # A dedicated search application built on top of Baloo
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mimetreeparser[0m # Parser for MIME trees
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.minuet[0m # Free and open-source software for music education
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mlt[0m # Open source multimedia framework, designed for television broadcasting
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.modemmanager-qt[0m # Qt wrapper for ModemManager DBus API
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.mpvqt[0m # MpvQt is a libmpv wrapper for QtQuick2 and QML
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.neochat[0m # A client for matrix, the decentralized communication protocol
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.networkmanager-qt[0m # Qt wrapper for NetworkManager API.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.ocean-sound-theme[0m # Ocean Sound Theme for Plasma
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.okular[0m # [32;1mKDE[0m document viewer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.oxygen[0m # The Oxygen Style for Qt/[32;1mKDE[0m Applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.oxygen-icons[0m # Oxygen icon theme
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.oxygen-sounds[0m # The Oxygen Sound Theme
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.packagekit-qt[0m # System to facilitate installing and updating packages - Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.palapeli[0m # Palapeli is a single-player jigsaw puzzle game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.parley[0m # Vocabulary Trainer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.partitionmanager[0m # Manage the disk devices, partitions and file systems on your computer
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.phonon[0m # Multi-platform sound framework for application developers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.phonon-vlc[0m # VLC backend for the Phonon multimedia library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.picmi[0m # A nonogram logic game by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.pim-data-exporter[0m # Application to assist you with backing up and archiving of PIM data
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.pim-sieve-editor[0m # Application to assist with editing IMAP Sieve filters
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.pimcommon[0m # Common library components for [32;1mKDE[0m PIM
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-activities[0m # Core components for the [32;1mKDE[0m's Activities System
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-activities-stats[0m # A library for accessing the usage data collected by the activities system.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-browser-integration[0m # Components necessary to integrate browsers into the Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-camera[0m # Camera application for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-desktop[0m # Plasma for the Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-dialer[0m # Dialer for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-disks[0m # Monitors S.M.A.R.T. capable devices for imminent failure.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-firewall[0m # Control Panel for your system firewall
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-integration[0m # Qt Platform Theme integration plugins for Plasma Workspaces
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-keyboard[0m # Virtual Keyboard for Qt based desktops
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-login-manager[0m # Plasma Login Manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-mobile[0m # Plasma shell for mobile devices
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-nano[0m # A minimal Plasma shell package
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-nm[0m # Plasma applet written in QML for managing network connections
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-pa[0m # Plasma applet for audio volume management using PulseAudio
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-pass[0m # Plasma applet for the Pass password manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-phonebook[0m # Phone book for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-sdk[0m # Applications useful for Plasma development
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-settings[0m # Settings application for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-setup[0m # Plasma first run setup tool
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-systemmonitor[0m # An interface for monitoring system sensors, process information and other system resources
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-thunderbolt[0m # Plasma integration for controlling Thunderbolt devices
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-vault[0m # Plasma applet and services for creating encrypted vaults
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-wayland-protocols[0m # Plasma-specific protocols for Wayland
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-welcome[0m # A friendly onboarding wizard for Plasma
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-workspace[0m # Various components needed to run a Plasma-based environment
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma-workspace-wallpapers[0m # Wallpapers for Plasma Workspaces
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasma5support[0m # Support components for porting from KF5/Qt5 to KF6/Qt6
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plasmatube[0m # Kirigami YouTube video player based on QtMultimedia and youtube-dl
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.plymouth-kcm[0m # KCM to manage the Plymouth (Boot) theme
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.polkit-[32;1mkde[0;1m-agent-1[0m # Daemon providing a Polkit authentication UI for Plasma
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.polkit-qt-1[0m # Qt wrapper around Polkit-1 client libraries
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.poppler[0m # PDF rendering library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.powerdevil[0m # Manages the power consumption settings of a Plasma shell
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.poxml[0m # Translate DocBook XML files using gettext PO files
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.print-manager[0m # A tool for managing print jobs and printers
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.prison[0m # prison is a barcode api currently offering a nice Qt api to produce QRCode barcodes and DataMatrix barcodes, and can easily be made support more.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.pulseaudio-qt[0m # Qt bindings for libpulse
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.purpose[0m # Framework for providing abstractions to get the developer's purposes fulfilled.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.pyotherside[0m # Asynchronous Python 3 Bindings for Qt 6
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qca[0m # Qt Cryptographic Architecture
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qcoro[0m # Library for using C++20 coroutines in connection with certain asynchronous Qt actions
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qcustomplot[0m # Qt C++ widget for plotting and data visualization
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qgpgme[0m # Qt API bindings/wrapper for GPGME
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qhotkey[0m # Global shortcut/hotkey for Desktop Qt-Applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qmake[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qmlbox2d[0m # QML plugin for Box2D engine
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qmlkonsole[0m # Terminal app for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qodeassist-plugin[0m # AI-powered coding assistant plugin for Qt Creator
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qqc2-breeze-style[0m # Breeze inspired QQC2 Style
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qqc2-desktop-style[0m # Qt Quick Controls 2: Desktop Style
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qrca[0m # QR code scanner for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qscintilla[0m # Qt port of the Scintilla text editing library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt-color-widgets[0m # Qt (C++) widgets to manage color inputs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt-jdenticon[0m # Qt plugin for generating highly recognizable identicons
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt3d[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt5compat[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt6ct[0m # Qt6 Configuration Tool
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qt6gtk2[0m # GTK+2.0 integration plugins for Qt6
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtbase[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtcharts[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtconnectivity[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtdatavis3d[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtdeclarative[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtdoc[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtforkawesome[0m # Library that bundles ForkAwesome for use within Qt applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtgraphs[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtgrpc[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qthttpserver[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtimageformats[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtkeychain[0m # Platform-independent Qt API for storing passwords securely
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtlanguageserver[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtlocation[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtlottie[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtmqtt[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtmultimedia[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtnetworkauth[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtpbfimageplugin[0m # Qt image plugin for displaying Mapbox vector tiles
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtpositioning[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtquick3d[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtquick3dphysics[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtquickeffectmaker[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtquicktimeline[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtremoteobjects[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtscxml[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtsensors[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtserialbus[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtserialport[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtshadertools[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtspeech[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtspell[0m # Provides spell-checking to Qt's text widgets, using the enchant spell-checking library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtstyleplugin-kvantum[0m # SVG-based Qt5 theme engine plus a config tool and extra themes
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtsvg[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qttools[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qttranslations[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtutilities[0m # Common Qt related C++ classes and routines used by @Martchus' applications such as dialogs, widgets and models Topics
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtvirtualkeyboard[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtwayland[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtwebchannel[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtwebengine[0m # Web engine based on the Chromium web browser
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtwebsockets[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qtwebview[0m # Cross-platform application framework for C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.quazip[0m # Provides access to ZIP archives from Qt programs
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qwt[0m # Qt widgets for technical applications
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qxlsx[0m # Excel file(*.xlsx) reader/writer library using Qt 5 or 6
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.qzxing[0m # Qt/QML wrapper library for the ZXing library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.rocs[0m # An educational Graph Theory IDE
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sailfish-access-control-plugin[0m # QML interface for sailfish-access-control
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sddm[0m # QML based X11 display manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sddm-kcm[0m # Configuration module for SDDM
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sddm-unwrapped[0m # QML based X11 display manager
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sierra-breeze-enhanced[0m # OSX-like window decoration for [32;1mKDE[0m Plasma written in C++
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.signon-kwallet-extension[0m # KWallet integration for the SignOn framework (gitlab.com/accounts-sso)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.signond[0m # Signon Daemon for Qt
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.skanlite[0m # Lite image scanning application
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.skanpage[0m # Utility to scan images and multi-page documents
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.skladnik[0m # Skladnik is the Japanese warehouse keeper sokoban game
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.solid[0m # Solid
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sonnet[0m # Spelling framework for Qt.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.spacebar[0m # SMS/MMS application for Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.spectacle[0m # Screenshot capture utility
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.step[0m # Interactive physics simulator
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.svgpart[0m # A KPart for SVG support
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.sweeper[0m # Application that helps to clean unwanted traces the user leaves on the system
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.syndication[0m # Syndication Library
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.syntax-highlighting[0m # Syntax highlighting Engine for Structured Text and Code.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.systemsettings[0m # Control center to configure your Plasma Desktop
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.taglib[0m # Library for reading and editing audio file metadata
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.telly-skout[0m # Convergent TV guide based on Kirigami.
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.threadweaver[0m # ThreadWeaver
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.timed[0m # Time daemon managing system time, time zone and settings
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.tokodon[0m # Tokodon is a Mastodon client for Plasma and Plasma Mobile
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.umbrello[0m # GUI for diagramming Unified Modelling Language (UML)
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wacomtablet[0m # GUI for Wacom Linux drivers that supports different button/pen layout profiles
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wallpaper-engine-plugin[0m # [32;1mKDE[0m wallpaper plugin integrating Wallpaper Engine
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wayland[0m # Core Wayland window system code and protocol
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wayland-protocols[0m # Wayland protocol extensions
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wayqt[0m # Qt-based library to handle Wayland and Wlroots protocols to be used with any Qt project
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wrapQtAppsHook[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.wrapQtAppsNoGuiHook[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.xdg-desktop-portal-[32;1mkde[0;1m[0m # A backend implementation for xdg-desktop-portal that is using Qt/[32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.yakuake[0m # Drop-down terminal emulator based on Konsole technologies
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.zanshin[0m # Getting Things Done application which aims at getting your mind like water
    # [0;1mlegacyPackages.x86_64-linux.[32;1mkde[0;1mPackages.zxing-cpp[0m # C++ port of zxing (a Java barcode image processing library)
    # [0;1mlegacyPackages.x86_64-linux.kdotool[0m # xdotool clone for [32;1mKDE[0m Wayland
    # [0;1mlegacyPackages.x86_64-linux.kid3-[32;1mkde[0;1m[0m # Simple and powerful audio tag editor
    # [0;1mlegacyPackages.x86_64-linux.kile[0m # User-friendly TeX/LaTeX authoring tool for the [32;1mKDE[0m desktop environment
    # [0;1mlegacyPackages.x86_64-linux.klassy[0m # Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the [32;1mKDE[0m Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.kmymoney[0m # Personal finance manager for [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.krename[0m # Powerful batch renamer for [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.krusader[0m # Norton/Total Commander clone for [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.kurve[0m # [32;1mKDE[0m Plasma widget displaying CAVA audio visualizations.
    # [0;1mlegacyPackages.x86_64-linux.libbloc[32;1mkde[0;1mv[0m # Library for manipulating block devices
    # [0;1mlegacyPackages.x86_64-linux.libcanberra_[32;1mkde[0;1m[0m # Implementation of the XDG Sound Theme and Name Specifications
    # [0;1mlegacyPackages.x86_64-linux.libsigro[32;1mkde[0;1mcode[0m # Protocol decoding library for the sigrok signal analysis software suite
    # [0;1mlegacyPackages.x86_64-linux.loc[32;1mkde[0;1mp[0m # Userspace locking validation tool built on the Linux kernel
    # [0;1mlegacyPackages.x86_64-linux.materia-[32;1mkde[0;1m-theme[0m # Port of the materia theme for Plasma
    # [0;1mlegacyPackages.x86_64-linux.mkcal[0m # Mobile version of the original KCAL from [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.nixbit[0m # [32;1mKDE[0m Plasma application to update your NixOS system from a git repository
    # [0;1mlegacyPackages.x86_64-linux.nordic[0m # Gtk and [32;1mKDE[0m themes using the Nord color pallete
    # [0;1mlegacyPackages.x86_64-linux.opencloud-desktop-shell-integration-dolphin[0m # OpenCloud Desktop shell integration for the great [32;1mKDE[0m Dolphin in [32;1mKDE[0m Frameworks 6
    # [0;1mlegacyPackages.x86_64-linux.oxygenfonts[0m # Desktop/gui font for integrated use with the [32;1mKDE[0m desktop
    # [0;1mlegacyPackages.x86_64-linux.perl5Packages.TestChec[32;1mkDe[0;1mps[0m # Check for presence of dependencies
    # [0;1mlegacyPackages.x86_64-linux.perlPackages.TestChec[32;1mkDe[0;1mps[0m # Check for presence of dependencies
    # [0;1mlegacyPackages.x86_64-linux.plasma-overdose-[32;1mkde[0;1m-theme[0m # Cute [32;1mKDE[0m theme inspired by the game Needy Girl Overdose
    # [0;1mlegacyPackages.x86_64-linux.plasma-panel-colorizer[0m # Fully-featured widget to bring Latte-Dock and WM status bar customization features to the default [32;1mKDE[0m Plasma panel
    # [0;1mlegacyPackages.x86_64-linux.plasma-panel-spacer-extended[0m # Spacer with mouse gestures for the [32;1mKDE[0m Plasma Panel
    # [0;1mlegacyPackages.x86_64-linux.plasmusic-toolbar[0m # [32;1mKDE[0m Plasma widget that shows currently playing song information and provide playback controls
    # [0;1mlegacyPackages.x86_64-linux.python313Packages.dar[32;1mkde[0;1mtect[0m # Detect OS Dark Mode from Python
    # [0;1mlegacyPackages.x86_64-linux.python313Packages.[32;1mkde[0;1m-material-you-colors[0m # Automatic color scheme generator from your wallpaper for [32;1mKDE[0m Plasma powered by Material You
    # [0;1mlegacyPackages.x86_64-linux.python313Packages.py[32;1mkde[0;1mbugparser[0m # [32;1mKde[0mbug events and ktraces parser
    # [0;1mlegacyPackages.x86_64-linux.python314Packages.dar[32;1mkde[0;1mtect[0m # Detect OS Dark Mode from Python
    # [0;1mlegacyPackages.x86_64-linux.python314Packages.[32;1mkde[0;1m-material-you-colors[0m # Automatic color scheme generator from your wallpaper for [32;1mKDE[0m Plasma powered by Material You
    # [0;1mlegacyPackages.x86_64-linux.python314Packages.py[32;1mkde[0;1mbugparser[0m # [32;1mKde[0mbug events and ktraces parser
    # [0;1mlegacyPackages.x86_64-linux.qogir-[32;1mkde[0;1m[0m # Flat Design theme for [32;1mKDE[0m Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.qt6Packages.sierra-breeze-enhanced[0m # OSX-like window decoration for [32;1mKDE[0m Plasma written in C++
    # [0;1mlegacyPackages.x86_64-linux.quassel[0m # Qt/[32;1mKDE[0m distributed IRC client supporting a remote daemon
    # [0;1mlegacyPackages.x86_64-linux.quasselClient[0m # Qt/[32;1mKDE[0m distributed IRC client supporting a remote daemon
    # [0;1mlegacyPackages.x86_64-linux.quasselDaemon[0m # Qt/[32;1mKDE[0m distributed IRC client supporting a remote daemon
    # [0;1mlegacyPackages.x86_64-linux.quic[32;1mkde[0;1mr[0m # Quick (and Easy) DER, a Library for parsing ASN.1
    # [0;1mlegacyPackages.x86_64-linux.r[32;1mkde[0;1mveloptool[0m # Tool from Rockchip to communicate with Rockusb devices
    # [0;1mlegacyPackages.x86_64-linux.r[32;1mkde[0;1mveloptool-pine64[0m # Tool from Rockchip to communicate with Rockusb devices (pine64 fork)
    # [0;1mlegacyPackages.x86_64-linux.ruqola[0m # [32;1mKDE[0m client for Rocket Chat
    # [0;1mlegacyPackages.x86_64-linux.skrooge[0m # Personal finances manager, powered by [32;1mKDE[0m
    # [0;1mlegacyPackages.x86_64-linux.supergfxctl-plasmoid[0m # [32;1mKDE[0m Plasma plasmoid for supergfxctl
    # [0;1mlegacyPackages.x86_64-linux.sweet-nova[0m # Dark and colorful, blurry theme for the [32;1mKDE[0m Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.twilight-[32;1mkde[0;1m[0m # Light, clean theme for [32;1mKDE[0m Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.umoc[32;1mkde[0;1mv[0m # Mock hardware devices for creating unit tests
    # [0;1mlegacyPackages.x86_64-linux.valent[0m # Implementation of the [32;1mKDE[0m Connect protocol, built on GNOME platform libraries
    # [0;1mlegacyPackages.x86_64-linux.v[32;1mkde[0;1mvicechooser[0m # Vulkan layer to force a specific device to be used
    # [0;1mlegacyPackages.x86_64-linux.vscode-extensions.ritwic[32;1mkde[0;1my.liveserver[0m
    # [0;1mlegacyPackages.x86_64-linux.whitesur-[32;1mkde[0;1m[0m # MacOS big sur like theme for [32;1mKDE[0m Plasma desktop
    # [0;1mlegacyPackages.x86_64-linux.wordpressPackages.plugins.h[32;1mkde[0;1mv-maintenance-mode[0m
    # [0;1mlegacyPackages.x86_64-linux.yaziPlugins.[32;1mkde[0;1mconnect-send[0m # Send selected files to your smartphone or other devices using [32;1mKDE[0m Connect
  ];
}
