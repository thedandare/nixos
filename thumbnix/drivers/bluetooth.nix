{ pkgs, inputs, ... }:
{

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


  # If you want to see what charge your bluetooth devices have you have to enable experimental features, which might lead to bugs (according to Arch Wiki). You can add the following to your config to enable experimental feature for bluetooth:
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  services.blueman.enable = true;
  }
