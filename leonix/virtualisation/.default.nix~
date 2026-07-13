{ ... }:
{
  imports = [
    ./incus.nix
    ./qemu-vms.nix
  ];
  virtualisation.docker = {
    enable = true;
    extraOptions = "--insecure-registry 192.168.0.11:32000";
    daemon.settings = {
      dns = [
        "192.168.0.2"
        "1.1.1.1"
      ];
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
      log-driver = "journald";
      registry-mirrors = [ "https://mirror.gcr.io" ];
      storage-driver = "overlay2";
    };

  };
}
