{ pkgs, ... }:
{
  # SMB - Server Message Block, is a protocol for sharing files, printers, serial ports, and communications abstractions such as named pipes and mail slots
  services.samba = {
    enable = true;
    smbd.enable = true;
    usershares = {
      enable = true; # Deve-se add o usr ao grupo
      group = "samba"; # members of which will be allowed to create usershares. ‼️ Will be created automatically.
    };
    nsswins = true; # Resolve WINS/NetBIOS names (a.k.a. Windows machine names) by transparently querying the winbindd daemon

    nmbd.enable = true; # replies to NetBIOS/IP name service requests and Win's “Network Neighborhood” view.
    settings = {
      global = {
        "invalid users" = [
          "rqbit"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
      };
      public = {
        browseable = "yes";
        comment = "Marquês de Sapucaí.";
        "guest ok" = "yes";
        path = "/home/public";
        "read only" = "no";
      };
    };
  };

  # Web Services Dynamic Discovery host daemon.
  services.samba-wsdd = {
    enable = true;
    discovery = true;
    hostname = "nixos";
    interface = "br0";
    workgroup = "osnix";
    extraOptions = [
      "--verbose"
      #         "--no-http"
      "--ipv4only"
      #         "--no-host"
      "--shortlog"

    ];
  };
}