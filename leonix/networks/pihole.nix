{ lib, pkgs, ... }:
let
  # Importa o arquivo de segredos centralizado
  secrets = import ../secret/default.nix;
  myLocalWhitelistFile = pkgs.writeText "pihole-whitelist.txt" ''
    challenges.cloudflare.com
    cloudflare.com
    hcaptcha.com
    recaptcha.net
    google.com
    gstatic.com
  '';

in
{
  # 1. Habilita o motor central do Pi-hole (FTLDNS)
  services.pihole-ftl = {
    enable = true;

    # The config is currently in read-only mode" acontece no NixOS?
    # O Pi-hole v6 joga esse erro no painel web sempre que ele detecta que não consegue salvar alterações no arquivo /etc/pihole/pihole.toml.

    useDnsmasqConfig = true; # Import options defined in services.dnsmasq.settings via misc.dnsmasq_lines in Pi-hole’s config.

    # Abrir portas no firewall automaticamente para DNS e DHCP
    openFirewallDNS = true;
    openFirewallDHCP = true;
    openFirewallWebserver = true;
    group = "wheel"; # default
    user = "pihole"; # default
    #     logDirectory = "/var/log/pihole";
    #     stateDirectory = "/var/lib/pihole"; # Path for pihole state files.
    settings = {
      misc.readOnly = false;
      misc.privacylevel = 0; # 0 = show everything, 3 = anonymous mode
      # Lista declarativa de Regex para permitir os domínios e TODOS os subdomínios deles
      regex.allow = [
        "(^|\\.)cloudflare\\.com$"
        "(^|\\.)hcaptcha\\.com$"
        "(^|\\.)recaptcha\\.net$"
        "(^|\\.)github\\.com$"
        "(^|\\.)google\\.com$"
        "(^|\\.)gstatic\\.com$"
        # 🛠️ ACRÉSCIMOS CRÍTICOS BASEADOS NO SEU LOG:
        "(^|\\.)adtrafficquality\\.google$" # Libera o validador de tráfego humano do Google
        "(^|\\.)googletagmanager\\.com$" # Permite a injeção limpa de scripts de autenticação
        "(^|\\.)reddit\\.com$" # Corrige a quebra de telemetria/erros do Reddit
      ];
      webserver = {
        "api.password" = "p[]"; # secrets.pihole.password;
        serve_all = true;
        # Define o tempo de expiração da sessão (opcional - exemplo de 12 horas)
        session.timeout = 43200;
      };
      # DNS SERVER
      dns = {
        upstreams = [
          "1.1.1.1"
          "8.8.8.8"
        ];

        cnameRecords = [
          "color-printer,office-printer"
          "color-printer.homelab.me,office-printer.homelab.me"
        ];
        domain = "custer.local";
        domainNeeded = true;
        expandHosts = true;
        interface = "enp5s0";
        hosts = [
          #           "192.168.0.1   gateway"
          #           "192.168.33.2   pi-hole"
          #           "192.168.33.15  nas"
        ];

      };
      # Let's not use Pi-hole time service. My home router provides clock.
      ntp = {
        ipv4.active = false;
        ipv6.active = false;
        sync.active = false;
      };
      # DHCP SERVER
      dhcp = {
        active = false; # <-- SET TO TRUE ONLY WHEN YOU'RE READY!
        end = "10.10.10.254";
        hosts = [
          #           "00:00:5e:00:53:01,192.168.33.22,jane-laptop"
          #           "00:00:5e:00:53:ab,bill-desktop"
          #           "00:00:5e:00:53:ff,office-printer"
        ];
        ipv6 = true;
        leaseTime = "24h";
        start = "10.10.10.1";
        rapidCommit = true;
        resolver = {
          resolveIPv6 = true;
        };
        router = "10.10.0.1/16";
      };
    };

    # Adicione suas Blocklists (Adlists) diretamente via código
    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "Lista Hagezi Pro";
      }
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black's unified adlist";
      }

      #       # Your whitelists to keep Cloudflare working smoothly
      #       {
      #         url = "file://${myLocalWhitelistFile}";
      #         type = "allow";
      #         enabled = true;
      #         description = "Commonly false-positive whitelisted domains";
      #       }
    ];

  };

  # 2. Habilita a Interface Web Administrativa do Pi-hole
  services.pihole-web = {
    enable = true;
    hostName = "leonix";
    ports = [
      314
      "14r"
      "24s"
    ];
  };

  services.resolved = {
    settings = {
      Resolve = {
        DNSStubListener = false;
        MulticastDNS = false;
      };
    };
  };

  # I'm not actually using the dnsmasq service. Pi-hole provides
  # it's own dnsmasq. I'm using Nix' ability to manage the
  # dnsmasq-style configuration file that Pi-hole utilizes.
  services.dnsmasq = {
    enable = false;
    settings = {
      address = [
        "/feelinsonice-hrd.appspot.com/ # Block Snapchat"
        "/feelinsonice.appspot.com/ # Block Snapchat"
        "/snapchat.com/ # Block Snapchat"
      ];
      dhcp-name-match = [
        "set:hostname-ignore,wpad"
        "set:hostname-ignore,localhost"
      ];
      # Set DHCP option 6 to the DNS server you nodes should use.
      dhcp-option = [
        "vendor:MSFT,2,1i"
        "6,192.168.33.2"
      ];
      domain = [
        "custer.local,192.168.0.0/24,local"
        "tilapia-buri.ts.net,100.64.0.0/10,local"
      ];

    };
  };

  system.activationScripts = {
    print-pi-hole = {
      text = builtins.trace "building the pi-hole configuration..." "";
    };
  };

}
