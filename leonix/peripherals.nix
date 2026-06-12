{ pkgs, ... }:

{

  # ⚡ AMD Ryzen CPU
  hardware.cpu.amd.ryzen-smu.enable = true; # A linux kernel driver that exposes access to the SMU (System Management Unit)
  programs.ryzen-monitor-ng.enable = true; # A userspace application for setting and getting Ryzen SMU parameters via the above driver.
  #hardware.cpu.amd.sev.enable = true; #[https://www.amd.com/en/developer/sev.html]

  #   virtualisation.xen.enable = true;
  #   virtualisation.xen.debug = true;

  # 🖥️ AMD Radeon GPU
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.amdgpu.overdrive.enable = true;
  hardware.facter.detected.graphics.amd.enable = true;
  hardware.amdgpu.initrd.enable = true;
  services.lact.enable = true; # LACT, a tool for monitoring, configuring and overclocking GPUs.
  programs.corectrl.enable = true; # CoreCtrl, a tool to overclock amd graphics cards and processors

  # 🎮 BLE
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      LE = {
        MinConnectionInterval = 16;
        MaxConnectionInterval = 16;
        ConnectionLatency = 10;
        ConnectionSupervisionTimeout = 100;
      };
    };
  };

  #Pairing hearing aids using the ASHA protocol
  boot.extraModprobeConfig = ''
    options bluetooth enable_ecred=1
  '';

  boot.kernelParams = [
    "boot.trace"
    "boot.shell_on_fail"
  ];

  # If you want to see what charge your bluetooth devices have you have to enable experimental features, which might lead to bugs (according to Arch Wiki). You can add the following to your config to enable experimental feature for bluetooth:
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  services.blueman.enable = true;

  # ⌨️ Keymap
  console.keyMap = "us";

  # 🔎 mDNS / Bonjour discovery
  services.avahi = {
    # Avahi is a system which facilitates
    enable = true; # service discovery on a local network
    nssmdns4 = true; # via the mDNS/DNS-SD protocol suite.
    openFirewall = true; # c.f.https://avahi.org/
  };

  #   # 🖨️ Printers
  services.printing = {
    enable = true; # CUPS
    drivers = with pkgs; [
      (writeTextDir "share/cups/model/canong3010.ppd" (builtins.readFile ./drivers/canong3010.ppd))
      cups-filters
      cups-browsed
      pkgs.cnijfilter2
    ];
  };

  # 🔊 Sound blasting.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # If you want to use JACK applications
  };
  security.rtkit.enable = true; # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.

  # 📳 Touchpad support
  services.xserver.libinput.enable = true;

}
