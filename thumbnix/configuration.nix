# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./drivers/bluetooth.nix
      ./networks/samba.nix
      ./virtualisation/incus.nix
      ./users
	];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
boot.kernelModules = [ "loop" "fuse" "overlay"  "squashfs" ];

	    nixpkgs.config = {
	        android_sdk.accept_license = true;
		    allowUnfree = true;
		      };

		        #  Seguranca
			  security.sudo.wheelNeedsPassword = false;


  systemd.network.enable = true;
  networking.useDHCP = false;
  networking.hostName = "thumbnix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.tailscale={
enable=true;

  }; 
  networking.bridges = {
	"lxcbr0" = {
interfaces = ["enp8s0"];
	};
  };

  networking.interfaces = {
	enp8s0.useDHCP = false;
	lxcbr0.useDHCP = true;

  };
	 
  environment.variables.EDITOR = "nvim";
  environment.shellAliases = {
    Sw = "sudo nixos-rebuild switch  --show-trace --print-build-logs --verbose";
	  
};

  # Enable network manager applet
  programs.nm-applet.enable = true;
  programs.neovim={
	viAlias = true;
	vimAlias = true;
	configure = {
 customRC = ''
    " here your custom VimScript configuration goes!
  '';
  customLuaRC = ''
    -- here your custom Lua configuration goes!
  '';
  /*packages.myVimPackage = with pkgs.vimPlugins; {
    # loaded on launch
    start = [ fugitive ];
    # manually loadable by calling `:packadd $plugin-name`
    opt = [ ];
   }; */		
	};
	enable=true;
};
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.

#  services.xserver.displayManager.lightdm.enable = true;
 # services.xserver.displayManager.defaultSession="xfce";
  services.xserver.desktopManager.xfce.enable = true;
services.xserver.desktopManager.xfce.enableXfwm = true;
  services.xserver.desktopManager.lxqt.enable = false;
#  services.desktopManager.gnome.enable = true;
# services.gnome.gnome-software.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  # Configure console keymap
  #console.keyMap = "dvorak";
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable =  true;
  services.touchegg.enable=true;
  services.buffyboard={
    settings.input.touchscreen=true;
    settings.theme.default="pmos-dark";

    extraFlags = [ "-dpi 192"];
    enable=true;
  };



  # Install firefox.
  programs.git.enable = true;
  programs.firefox.enable = true;
	programs.chromium.enable=true;  
	programs.zsh={
	enable=true;
	};

	programs.bash={
	enable=true;
	};
	programs.tmux={
	enable=true;
	};


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

  lxc 

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  # 🫵
wget
toybox
fusuma
# IMPORTANT: You MUST be a member of the INPUT group to read touchpad by Fusuma.
	chicago95

	wf-touch


	darkly
 	lorien # Note taking app
	lan-mouse
	squeekboard # virtual keyboard
  	maliit-keyboard
   	kdePackages.plasma-keyboard
	kdePackages.qtvirtualkeyboard        

	# LXC LXC LXC LXC	
 	lxc
	tigervnc
	remmina
#"packages.remote-viewer"
  ];
	services.xrdp.enable = true;
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma6.enable = true;
	services.xserver.resolutions=[{
	x=1920; y=1080;
	}
	{x=1280; y= 720;}
	{x=1366; y= 768;
	}];
	#services.xrdp.defaultWindowManager = "startplasma-wayland";
	services.xrdp.openFirewall = true;

	 services.x2goserver.enable = true;
	services.displayManager.autoLogin.enable = false;
#	services.displayManager.autoLogin.user = "leo";  
  # Some programs need SUID wrappers, can be configured further or are

		  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
services.openssh = {
  enable = true;
  ports = [ 22 ];
  settings = {
    PasswordAuthentication = true;
    AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
    UseDns = true;
    X11Forwarding = true;
    PermitRootLogin = "yes"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
  };
};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
