{ ... }:

let
  # Importa o arquivo de segredos centralizado
  secrets = import ../secret/default.nix;
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
    group = "pihole"; # default
    user = "pihole"; # default
    logDirectory = "/var/log/pihole";
    stateDirectory = "/var/lib/pihole"; # Path for pihole state files.
    settings = {
      # Servidores DNS de Upstream (onde ele busca quando não está bloqueado)
      dns.upstreams = [
        "1.1.1.1" # Cloudflare
        "9.9.9.9" # Quad9
      ];
      webserver = {
        # Consome a hash de forma limpa e dinâmica direto do barrel de segredos
        "webserver.api.pwhash" = secrets.pihole.pwhash;

      };
      # Define o tempo de expiração da sessão (opcional - exemplo de 12 horas)
      "webserver.session.timeout" = 43200;
    };

    # Adicione suas Blocklists (Adlists) diretamente via código
    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "Lista Hagezi Pro";
      }
    ];
  };

  # 2. Habilita a Interface Web Administrativa do Pi-hole
  services.pihole-web = {
    enable = true;
    hostName = "pihl";
    ports = [
      314
      "14r"
      "24s"
    ];
  };
}
