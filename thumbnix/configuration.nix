# 🥧 ➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🥧
# 🥧  Leo's raspberry-pi-4b Nixos stp   🥧
# 🥧                                   🥧
# 🥧                                   🥧
# 🥧 ➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🥧

{ config, pkgs, lib, ... }:

let
  user = "leo";
  password = if builtins.getEnv "USER_PWD" != "" then builtins.getEnv "USER_PWD" else "Senha171";
  rootpwd  = if builtins.getEnv "ROOT_PWD" != "" then builtins.getEnv "ROOT_PWD" else "toor171";
  userSshKey =
    if builtins.getEnv "SSH_KEY" != "" then
      builtins.getEnv "SSH_KEY"
    else
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICs+sOj/1GK5exkDkCw7H7zmDapshfWaRn474qxZxSUY leo";
  rootSshKey =
    if builtins.getEnv "SSH_KEY_ROOT" != "" then
      builtins.getEnv "SSH_KEY_ROOT"
    else
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGWvbEP/E0dh/xwtUVIuQrNDSz+G4TCLA+UMVpT0gLi root@ali";

  SSID = "THIS_IS_US";
  SSIDpassword = "C@fezinho403";
  interface = "wlan0";
  hostname = "pinix";
in {

  imports = [
    <nixos-hardware/raspberry-pi/4>
    "/etc/nixos/turbovnc.nix"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

# Gráficos e Suporte ao Pi 4
  hardware.graphics.enable = true; # Nota: 'hardware.opengl' virou 'hardware.graphics' nas versões novas
  hardware.raspberry-pi."4"={
touch-ft5406.enable=true;
	bluetooth.enable = true;
	fkms-3d.enable=true;
	apply-overlays-dtmerge.enable = true;};

  # 🛠️ Ativação do SPI via Device Tree Overlays
 hardware.deviceTree = {
enable = true;
    # Mudamos o filtro para aplicar SOMENTE no arquivo correto do Raspberry Pi 4B normal,
    # ignorando variações CM4/Zero que quebram o build.
    filter = "bcm2711-rpi-4*.dtb";
    overlays = [
      {
        name = "spi0-1cs";
        dtboFile = pkgs.runCommand "spi0-1cs" { nativeBuildInputs = [ pkgs.dtc ]; } ''
          dtc -I dtb -o spi0-1cs.dtso -O dts ${pkgs.device-tree_rpi.overlays}/spi0-1cs.dtbo
          substituteInPlace spi0-1cs.dtso --replace-fail "compatible = \"brcm,bcm2835\";" "compatible = \"brcm,bcm2711\";"
          dtc -I dts -o $out -O dtb spi0-1cs.dtso
        '';
      }
    ];
  };

  # Permissões do barramento SPI para usuários comuns
  services.udev.extraRules = ''
    SUBSYSTEM=="spidev", KERNEL=="spidev0.*", GROUP="spi", MODE="0660"
  '';
  users.groups.spi = {};

  boot = {
    kernelPackages =  pkgs.linuxPackages_rpi4;  #pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    initrd.systemd.enableTpm2 = false;

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    # Módulos para a tela LCD de 3.5" via SPI (FBTFT)
    kernelModules = [
      "fb_ili9486"     # Driver do display
      "ads7846"        # Driver do Touchscreen
    ];

    extraModprobeConfig = "options fbtft_device name=piscreen gpios=dc:24,reset:25 speed=24000000 options virtual_display=0000:01:00.0,1";

    kernelParams = [
  #    "modules-load=fbtft_device"
  #    "fbtft_device.name=piscreen"
  #    "fbtft_device.speed=24000000"
  #    "fbtft_device.rotate=90"
  #    "fbcon=map:10" # Joga o console do Linux na tela SPI
        # 🔴 CORREÇÃO AQUI: Passamos explicitamente os pinos GPIO padrão para telas 3.5" no Pi 4B
  #  "fbtft_device.gpios=dc:24,reset:25"

    # 🔴 Audio HDMI:
  #  "dtparam=audio=on"
  #  "snd_bcm2835.enable_hdmi=1"
    ];


  };

  # Configuração do touch no X11
 # services.xserver.inputClassSections = [
 #   ''
 #     Identifier "Configuracao Touchscreen SPI"
 #     MatchIsTouchscreen "on"
 #     MatchDevicePath "/dev/input/event*"
 #     Driver "evdev"
  #    Option "SwapXY" "0"
   #   Option "InvertX" "0"
   #   Option "InvertY" "0"
   # ''
  #];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    networkmanager.enable = false;

    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
  
    kdePackages.kfind
    kdePackages.kate
    kdePackages.qtvirtualkeyboard 
qt6.qtvirtualkeyboard
gtop
    neovim
    gnvim
    turbovnc
    virtualgl
    remmina
    xrdp
    firefox
    google-chrome
    cool-retro-term
    bluez
    bluez-tools
    x2goserver
xauth 
xinit
xdm

k9s
gnomeExtensions.x11-gestures
gnomeExtensions.touchup
 gnomeExtensions.window-gestures

#gnome-applets
 #gnomeExtensions.all-in-one-clipboard
# Gaming
    retroarch
  retroarch-joypad-autoconfig
      pkgs.retroarch-assets
    
    
    # Themes
    chicago95
    
    ];

      services.xrdp.defaultWindowManager = "gdm";

  # Interface Gráfica (SDDM + Plasma 6)
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "alt-intl";
    };
    windowManager = {
      xmonad = {
        enable = false;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };
    };
desktopManager.xfce={
      enable=true;
      enableScreensaver=true;
      enableWaylandSession=true;
enableXfwm=false;
    };
  };
  services.xserver.displayManager.gdm = {
  enable = true;
  autoSuspend = false;
  };
  
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;
  };
     services.displayManager.autoLogin = {
      enable = true;
      user = "leo";
    };
  services.desktopManager.plasma6.enable = false;
  services.displayManager.defaultSession = "labwc";

  # SSH
  services.openssh = {
    enable = true;
    extraConfig = "PermitRootLogin yes";
    settings ={
	X11Forwarding = true;
    };
    startWhenNeeded = true;
  };

    services.zabbixServer.enable = true;


  # Usuários
  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      # Adicionado o grupo "spi" para o Leo conseguir ler a tela sem usar sudo
      extraGroups = [ "wheel" "spi" ];
      openssh.authorizedKeys.keys = [ userSshKey rootSshKey];
    };
    users."root" = {
      password = rootpwd;
      openssh.authorizedKeys.keys = [ rootSshKey];
    };
  };

  # Programas do Sistema
  programs.tmux.enable = true;
  programs.chromium.enable = true;
  programs.zsh.enable = true;

  # 🗝️ Segurança e Polkit
  security.sudo.wheelNeedsPassword = false;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

    # 🔵 Ativa o suporte ao Bluetooth e o daemon do Bluez
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Liga o Bluetooth automaticamente ao iniciar
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Melhora compatibilidade com fones de ouvido
      };
    };
  };

  # Garante que os pacotes e interfaces de áudio Bluetooth funcionem no sistema
  services.blueman.enable = true; # Instala o gerenciador gráfico Blueman (útil no Plasma/XFCE)

 # 🔊 Configuração do Servidor de Áudio (PipeWire)
  hardware.pulseaudio.enable = false; # Desativa o PulseAudio legado
  security.rtkit.enable = true;       # Necessário para prioridade de tempo real do áudio

  services.pipewire = {
enable = true;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false; # Permite que o KDE Plasma controle o volume facilmente
  };
 services.x2goserver={
  enable = true;
  nxagentDefaultOptions = [
    "-extension GLX"
  ];
  settings = {
  	superenicer = {
    		"enable" = "yes";
    		"idle-nice-level" = 19;
  	};
  		telekinesis = { "enable" = "yes"; };
	};
 };


  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:${pkgs.virtualgl}/lib";
    VGL_DISPLAY = "/dev/dri/card0"; # Garante que o VirtualGL use a GPU do Pi 4
  };

  environment.shellAliases = {
    vi = "nvim";
    vim = "gnvim";

    E = "tmux split-window edit";
    Bt = "sudo nixos-rebuild boot  --show-trace";
    Tst = "sudo nixos-rebuild test  --show-trace";
    Sw = "sudo nixos-rebuild switch";
    B = "sudo nixos-rebuild switch";
    Rbt = "sudo shutdown -r now";
    };
    
    
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "26.05";
}
