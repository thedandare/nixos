{ pkgs, ... }:
{
  imports = [
    ./samba.nix
    ./bonjour.nix
    ./pihole.nix
  ];
  systemd.network.enable = true;
  systemd.network.wait-online.enable = false;
  networking.hostName = "leonix";
  networking.networkmanager.enable = true;

  # Firewalling
  # Isso força o NixOS a garantir que o ecossistema iptables/nftables básico seja carregado
  networking.firewall.enable = false; # [ pois =true  Nao funciona!]
  # Ativa o nftables exigido pelo Incus no NixOS [Solucao!]
  networking.nftables.enable = true;
  networking.nat.enable = true;
  # CORREÇÃO REAL: Força o nftables do host NixOS a liberar o tráfego do Kubernetes na bridge
  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        type filter hook input priority filter; policy accept;
      }
      # ADICIONADO: Permite que os nós do Kubernetes conversem entre si através da br0
      chain forward {
        type filter hook forward priority filter; policy accept;
      }
    }
  '';

  # TCP/IP
  networking.useDHCP = false; # off by defalut, enable per-interface

  networking.bridges = {
    "br0" = {
      interfaces = [ "enp7s0" ];
    };
  };
  networking.interfaces = {
    enp7s0.useDHCP = false; # Interface is bridged
    br0.useDHCP = false; # Bridge gets IP via DHCP
  };

  # libera a rede em Bridge para o QEMU
  security.wrappers.qemu-bridge-helper = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.qemu}/libexec/qemu-bridge-helper";
  };

  # E configure quais bridges são permitidas criando o arquivo de ACL do QEMU:
  environment.etc."qemu/bridge.conf".text = ''
    allow br0
  '';

  networking.interfaces.br0.ipv4.routes = [
    {
      # Configure the prefix route.
      address = "192.168.1.0";
      prefixLength = 24;
      via = "192.168.0.15";
    }
  ];
  networking.interfaces.br0.ipv4.addresses = [
    {
      address = "192.168.0.10";
      prefixLength = 24;

    }
  ];

  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [
    "192.168.0.1"
    "1.1.1.1"
  ];

}

# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Proxing
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#   systemd.network = {
#     netdevs = {
#       # 2. Define the TAP device
#       "20-tap1" = {
#         enable = true;
#         netdevConfig = {
#           Kind = "tap";
#           Name = "tap1";
#         };
#       };
#     };
#     networks = {
#       # 3. Configure the TAP device
#       "40-tap1" = {
#         matchConfig.Name = "tap1";
#         # Optional: Bring interface up automatically
#         linkConfig.ActivationPolicy = "always-up";
#         # Add networking directives (e.g., static IP, bridging) here if needed
#       };
#     };
#   };
