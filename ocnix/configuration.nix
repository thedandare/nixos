	{ config, pkgs, lib, ... }:

let
  segredos = {
    tailscale = {
      clientId = "kxixTezVgB21CNTRL";
      clientSecret = "tskey-client-kxixTezVgB21CNTRL-jiN4D8nU7sbYCg1vcCtWrb1nA2D4gRCa";
    };
  };
  

  cloudInitRaw = ''
    #cloud-config
    package_update: true
    package_upgrade: true

    users:
      - name: root
        ssh_authorized_keys:
          - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICs+sOj/1GK5exkDkCw7H7zmDapshfWaRn474qxZxSUY leo"
          - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGWvbEP/E0dh/xwtUVIuQrNDSz+G4TCLA+UMVpT0gLi root@ali"
          - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlCOf70p6jujZf6ZdE7ugOQAPtpqteigxxaQb4RONs4 thedandare@gmail.com"
          - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4x8pXKybfzCbc6IAd+HoPMW4vy3vT6ByGHM3uz4ApN leo@ali"

    ssh_pwauth: true
    chpasswd:
      list:
        - root:Senha171
      expire: false

    write_files:
      - path: /etc/tailscale_auth.env
        content: |
            TS_AUTH_KEY=INJECT_CLIENT_SECRET
            TS_ID=INJECT_CLIENT_ID

      - path: /etc/sysctl.d/99-kubernetes.conf
        permissions: '0644'
        content: |
          net.ipv4.ip_forward = 1
          fs.inotify.max_user_instances = 512
          fs.inotify.max_user_watches = 524288
          net.bridge.bridge-nf-call-iptables = 1
          net.bridge.bridge-nf-call-ip6tables = 1

      - path: /usr/local/bin/autoconnect-tailscale.sh
        permissions: '0755'
        encoding: b64
        content: INJECT_TAILSCALE_B64_HERE

    runcmd:
      - ip addr add 10.10.10.2/24 dev eth0 || true
      - ip route add default via 10.10.10.1 || true
      - chattr -i /etc/resolv.conf || true
      - echo "nameserver 1.1.1.1" > /etc/resolv.conf
      - chattr +i /etc/resolv.conf
      - apt-get update
      - apt-get install -y snapd jq curl
      - systemctl unmask snapd.service snapd.socket || true
      - systemctl enable snapd.service snapd.socket || true
      - systemctl start snapd.service snapd.socket || true

      - curl -fsSL https://tailscale.com/install.sh | sh
      - sleep 2
      - tailscale up --auth-key=tskey-auth-kmTLYD4YpF11CNTRL-UfNAWAmZYcWq6hpmMYSAdWtt7gSFwENk || /usr/local/bin/autoconnect-tailscale.sh

      - snap install microk8s --channel=1.36/stable --classic
      - snap refresh --hold microk8s

      - sed -i 's/snapshotter = "''${SNAPSHOTTER}"/snapshotter = "overlayfs"/g' /var/snap/microk8s/current/args/containerd-template.toml
      - grep -qxF -- '--protect-kernel-defaults=false' /var/snap/microk8s/current/args/kubelet || echo '--protect-kernel-defaults=false' >> /var/snap/microk8s/current/args/kubelet
      - grep -qxF -- '--enforce-node-allocatable=""' /var/snap/microk8s/current/args/kubelet || echo '--enforce-node-allocatable=""' >> /var/snap/microk8s/current/args/kubelet

      - mkdir -p /var/snap/microk8s/current/args/cni-network
      - grep -qxF -- '--cni-conf-dir=/var/snap/microk8s/current/args/cni-network' /var/snap/microk8s/current/args/kubelet || echo '--cni-conf-dir=/var/snap/microk8s/current/args/cni-network' >> /var/snap/microk8s/current/args/kubelet

      - sed -i '/^--proxy-mode=/d' /var/snap/microk8s/current/args/kube-proxy
      - echo '--proxy-mode=nftables' >> /var/snap/microk8s/current/args/kube-proxy
      - prlimit --pid=$$ --nofile=1048576:1048576 || true
      - mkdir -p /etc/systemd/system/snap.microk8s.daemon-kubelite.service.d
      - |
        cat <<EOF > /etc/systemd/system/snap.microk8s.daemon-kubelite.service.d/override.conf
        [Service]
        LimitNOFILE=1048576
        LimitNPROC=512000
        EOF
      - systemctl daemon-reload
      - rm -f /var/snap/microk8s/current/var/kubernetes/backend/kine.sock
      - chmod -R 777 /var/snap/microk8s/current/var/kubernetes/backend/

      - sysctl --system
      - ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf || true
      - snap set system refresh.hold=forever

      - snap restart microk8s
      - microk8s status --wait-ready
  '';

  cloudInitConfig = builtins.replaceStrings
    [ "INJECT_CLIENT_ID" "INJECT_CLIENT_SECRET" "INJECT_TAILSCALE_B64_HERE" ]
    [ segredos.tailscale.clientId segredos.tailscale.clientSecret "IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLWV1byBwaXBlZmFpbAoKIyBGb3LDp2EgbyBjYXJyZWdhbWVudG8gZGFzIHZhcmnDoXZlaXMgaW5qZXRhZGFzIHBlbG8gcGVyZmlsIGRvIEluY3VzCiMgc2UgbyBhcnF1aXZvIGV4aXN0aXIsIGxpbXBhbmRvIGVzY2FwZXMgaW5kZXNlamFkb3MKWyAtZiAvZXRjL2Vudmlyb25tZW50IF0gJiYgc291cmNlIC9ldGMvZW52aXJvbm1lbnQKCmVjaG8gIj09PSAxLiBTb2xpY2l0YW5kbyBBY2Nlc3MgVG9rZW4gdmlhIE9BdXRoID09PSIKIyBBanVzdGFkbyBwYXJhIHVzYXIgbyBDb250ZW50LVR5cGUgb2ZpY2lhbCBleGlnaWRvIHBvciB2YWxpZGFkb3JlcyBlc3RyaXRvcwpBUElfUkVTUE9OU0U9JChjdXJsIC1zIC1YIFBPU1QgXAogIC1IICJDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL3gtd3d3LWZvcm0tdXJsZW5jb2RlZCIgXAogIC1kICJncmFudF90eXBlPWNsaWVudF9jcmVkZW50aWFscyIgXAogIC1kICJjbGllbnRfaWQ9JFRBSUxTQ0FMRV9DTElFTlRfSUQiIFwKICAtZCAiY2xpZW50X3NlY3JldD0kVEFJTFNDQUxFX0NMSUVOVF9TRUNSRVQiIFwKICAiaHR0cHM6Ly9hcGkudGFpbHNjYWxlLmNvbS9hcGkvdjIvb2F1dGgvdG9rZW4iKQoKQVBJX1RPS0VOPSQoZWNobyAiJHtBUElfUkVTUE9OU0V9IiB8IGpxIC1yICcuYWNjZXNzX3Rva2VuIC8vIGVtcHR5JykKIyBORVdUX0NPTE9SUz0nCiMgICByb290PXdoaXRlLGdyYXkKIyAgIHdpbmRvdz13aGl0ZSxicm93bgojICAgYm9yZGVyPXdoaXRlLHJlZAojICAgdGV4dGJveD13aGl0ZSxyZWQKIyAgIGJ1dHRvbj1ibGFjayx3aGl0ZQojICcKIyBpZiBbIC16ICIke0FQSV9UT0tFTn0iIF07IHRoZW4KICAgICMgd2hpcHRhaWwgLS1tc2dib3ggICIgUmVzcG9zdGEgZG8gc2Vydmlkb3I6JHtBUElfUkVTUE9OU0V9IiAxMCAxMDAgLS10aXRsZSAiRVJSTzogRmFsaGEgYW8gb2J0ZXIgQVBJX1RPS0VOLiIKICAgICMgZXhpdCAxCiMgZmkKIyB3aGlwdGFpbCAtLW1zZ2JveCAiVG9rZW46ICR7QVBJX1RPS0VOfSIgMTAgMTAwIC0tdGl0bGUgIkFjY2VzcyBUb2tlbiBvYnRpZG8gY29tIHN1Y2Vzc28uIgoKZWNobyAiPT09IDIuIEdlcmFuZG8gQXV0aCBLZXkgRGVzY2FydMOhdmVsID09PSIKIyBSZXF1aXNpw6fDo28gZXN0cnV0dXJhZGEgY29tIEJlYXJlciBUb2tlbiBsaW1wbwpLRVlfUkVTUE9OU0U9JChjdXJsIC1zIC1YIFBPU1QgXAogIC1IICJBdXRob3JpemF0aW9uOiBCZWFyZXIgJHtBUElfVE9LRU59IiBcCiAgLUggIkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vanNvbiIgXAogIC1kICd7CiAgICAiY2FwYWJpbGl0aWVzIjogewogICAgICAiZGV2aWNlcyI6IHsKICAgICAgICAiY3JlYXRlIjogewogICAgICAgICAgInJldXNhYmxlIjogZmFsc2UsCiAgICAgICAgICAiZXBoZW1lcmFsIjogdHJ1ZSwKICAgICAgICAgICJwcmVhdXRob3JpemVkIjogdHJ1ZSwKICAgICAgICAgICJ0YWdzIjogWyJ0YWc6dGVzdGUiLCAidGFnOmNhbnNzaCJdCiAgICAgICAgfQogICAgICB9CiAgICB9LAogICAgImV4cGlyeVNlY29uZHMiOiA2MDAKICB9JyBcCiAgImh0dHBzOi8vYXBpLnRhaWxzY2FsZS5jb20vYXBpL3YyL3RhaWxuZXQvLS9rZXlzIikKClJFUV9LRVk9JChlY2hvICIke0tFWV9SRVNQT05TRX0iIHwganEgLXIgJy5rZXkgLy8gZW1wdHknKQoKaWYgWyAteiAiJHtSRVFfS0VZfSIgXTsgdGhlbgogICAgZWNobyAiRVJSTzogRmFsaGEgYW8gb2J0ZXIgUkVRX0tFWS4gUmVzcG9zdGEgZG8gc2Vydmlkb3I6IgogICAgZWNobyAiJHtLRVlfUkVTUE9OU0V9IgogICAgZXhpdCAxCmZpCmVjaG8gIkF1dGggS2V5IGRlc2NhcnTDoXZlbCBnZXJhZGE6IHRza2V5LWF1dGgtLi4uIgoKZWNobyAiPT09IDMuIEF1dGVudGljYW5kbyBuYSBSZWRlIFRhaWxzY2FsZSA9PT0iCiMgTGltcGEgZXN0YWRvIGFudGVyaW9yIChuZWNlc3PDoXJpbyBwYXJhIGNsb25lcyBkZSBjb250YWluZXIpCnRhaWxzY2FsZSBsb2dvdXQgMj4vZGV2L251bGwgfHwgdHJ1ZQpybSAtZiAvdmFyL2xpYi90YWlsc2NhbGUvdGFpbHNjYWxlZC5zdGF0ZQojIEV4ZWN1dGEgYSBqdW7Dp8OjbyDDoCBtYWxoYSB1c2FuZG8gYSBjaGF2ZSB2YWxpZGFkYQp0YWlsc2NhbGUgdXAgLS1hdXRoLWtleT0iJHtSRVFfS0VZfSIgLS1hY2NlcHQtZG5zPXRydWUgLS1zc2g9dHJ1ZSAtLXN0YXRlZnVsLWZpbHRlcmluZz1mYWxzZQplY2hvICJOw7MgYXV0ZW50aWNhZG8gY29tIHN1Y2Vzc28hIgoKICAgICMgVE9PRCBFU1RBTU9TIEFRVUkKICAgICMgc291cmNlIC4vdGFpbHNjYWxlX2Nob29zZV9pcC5zaAogZWNobyAiPT09IDQuIEV4dHJhaW5kbyBlIEZpeGFuZG8gbyBJUCBkYSBJbnRlcmZhY2UgVGFpbHNjYWxlID09PSIKICAgIyBBZ3VhcmRhIGF0w6kgcXVlIGEgaW50ZXJmYWNlIHRhaWxzY2FsZTAgZ2FuaGUgdW0gSVAgdsOhbGlkbyAoVGltZW91dCBkZSAxNSBzZWd1bmRvcykKVEFJTFNDQUxFX0lQPSIiCmZvciB0cmllcyBpbiB7MS4uMTV9OyBkbwogICAgVEFJTFNDQUxFX0lQPSQoaXAgLTQgYWRkciBzaG93IGRldiB0YWlsc2NhbGUwIDI+L2Rldi9udWxsIHwgYXdrICcvaW5ldCAvIHtwcmludCAkMn0nIHwgY3V0IC1kLyAtZjEpCiAgICBbIC1uICIke1RBSUxTQ0FMRV9JUH0iIF0gJiYgYnJlYWsKICAgIGVjaG8gIkFndWFyZGFuZG8gaW50ZXJmYWNlIHRhaWxzY2FsZTAgZ2FuaGFyIElQLi4uIChUZW50YXRpdmEgJHRyaWVzLzE1KSIKICAgIHNsZWVwIDEKZG9uZQoKaWYgWyAteiAiJHtUQUlMU0NBTEVfSVB9IiBdOyB0aGVuCiAgICBlY2hvICJFUlJPIENSSVRJQ086IEludGVyZmFjZSB0YWlsc2NhbGUwIHN1Yml1LCBtYXMgbmFvIHJlY2ViZXUgSVAgYSB0ZW1wby4iCiAgICBleGl0IDEKZmkKZWNobyAiSVAgZXh0cmFpZG8gY29tIHN1Y2Vzc286ICR7VEFJTFNDQUxFX0lQfSIKCmV4cG9ydCBNSUNST0s4U19JUD0iJHtUQUlMU0NBTEVfSVB9IgoKICAgICMgRXhlY3V0YSBvIHNlbGV0b3IgZGUgSVAgZW0gY29uZm9ybWlkYWRlIGNvbSBvIGFtYmllbnRlIGF0dWFsIChVYnVudHUvTml4T1MpCiAgICBpZiBbIC1mICIuL3RhaWxzY2FsZV9jaG9vc2VfaXAuc2giIF07IHRoZW4KICAgICAgICBzb3VyY2UgIi4vdGFpbHNjYWxlX2Nob29zZV9pcC5zaCIKICAgIGVsc2UKICAgICAgICBlY2hvICJBdmlzbzogU2NyaXB0IHRhaWxzY2FsZV9jaG9vc2VfaXAuc2ggbmFvIGxvY2FsaXphZG8uIFByb3NzZWd1aW5kby4uLiIKICAgIGZpCgpzbGVlcCA1CnRhaWxzY2FsZSBzZXQgLS13ZWJjbGllbnQ9dHJ1ZQp0YWlsc2NhbGUgZnVubmVsIC0tYmcgLS1odHRwIDgwIDUyNTIKdGFpbHNjYWxlIHNlcnZlIC0tYmcgLS10Y3AgMjQwOSAzMzg5CnRhaWxzY2FsZSBzZXJ2ZSAtLWJnIC0tdGNwIDI0MTAgNTkwMQojIHRhaWxzY2FsZSBmdW5uZWwgLS1iZyAtLXRjcCAyNDA5IDIyCg==" ]
    cloudInitRaw;
networkConfig = ''
  version: 2
  ethernets:
    eth0:
      addresses:
        - 10.10.10.2/24
      routes:
        - to: default
          via: 10.10.10.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
'';

 in
{

  imports = [./hardware-configuration.nix];

  networking.hostName = "ocnix";
  networking.nftables.enable = true;

  # Bridge standalone para o Incus (sem interface fisica anexada, seguro em instancia AWS com 1 NIC).
  # O leonix/networks/default.nix usa "enp7s0" (bare-metal com NIC dedicada); aqui nao ha NIC extra,
  # entao o br0 fica isolado e o trafego sai via NAT/masquerade pela interface principal.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
            device = "nodev";
	};
   };


  networking.bridges."br0".interfaces = [ ];
  networking.interfaces.br0.ipv4.addresses = [
    {
      address = "10.10.10.1";
      prefixLength = 24;
    }
  ];
networking.nameservers = [
  "1.1.1.1"          # Cloudflare Public DNS (Reliable fallback for the internet)
];

  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        type filter hook input priority filter; policy accept;
      }
      chain forward {
        type filter hook forward priority filter; policy accept;
      }
    }
    table ip nat {
      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;
        ip saddr 10.10.10.0/24 oifname != "br0" masquerade
      }
    }
  '';

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4x8pXKybfzCbc6IAd+HoPMW4vy3vT6ByGHM3uz4ApN leo@ali"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGWvbEP/E0dh/xwtUVIuQrNDSz+G4TCLA+UMVpT0gLi root@ali"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlCOf70p6jujZf6ZdE7ugOQAPtpqteigxxaQb4RONs4 thedandare@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICs+sOj/1GK5exkDkCw7H7zmDapshfWaRn474qxZxSUY leo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICs+sOj/1GK5exkDkCw7H7zmDapshfWaRn474qxZxSUY leo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4x8pXKybfzCbc6IAd+HoPMW4vy3vT6ByGHM3uz4ApN leo@ali"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGWvbEP/E0dh/xwtUVIuQrNDSz+G4TCLA+UMVpT0gLi root@ali"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlCOf70p6jujZf6ZdE7ugOQAPtpqteigxxaQb4RONs4 thedandare@gmail.com"
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.tmux.enable = true;
  programs.neovim.enable = true;
 environment.systemPackages = with pkgs; [
  git vim newt
    coreutils   # utilitários POSIX essenciais; binários: ls, cp, mv, rm, cat, echo, mkdir, chmod, chown, date, head, tail, wc, sort, uniq, cut, tr, tee, pwd, touch, ln, stat, df, du, id, whoami, env, sleep, kill, …
    findutils   # busca de arquivos no sistema; binários: find, xargs, locate, updatedb
    gnugrep     # busca de padrões em texto (regex); binários: grep, egrep, fgrep
    gnused      # editor de fluxo para substituição/transformação de texto; binários: sed
    htop        # monitor de processos interativo (top melhorado); binários: htop
    iproute2    # configuração de rede moderna (substitui net-tools); binários: ip, ss, tc, bridge, nstat, routel
    jq          # processamento e filtragem de JSON na linha de comando; binários: jq
  ];
  security.sudo.wheelNeedsPassword = false;


 # https://wiki.nixos.org/wiki/Tailscale
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = "/etc/nixos/secret/tailscale_key";
    serve = {
      enable = true;
      configFile = "/etc/nixos/tailscale-serve.json";
    };
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled = {
    after = [ "provision-secrets.service" ];
    requires = [ "provision-secrets.service" ];
    serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
  };

  systemd.services.provision-secrets = {
    description = "Provisiona arquivos de configuracao e secrets";
    after = [ "network-online.target" ];
    before = [ "tailscaled.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      mkdir -p /etc/nixos/secret

      cat > /etc/nixos/secret/tailscale_key << 'EOF'
tskey-auth-kmTLYD4YpF11CNTRL-UfNAWAmZYcWq6hpmMYSAdWtt7gSFwENk
EOF

      cat > /etc/nixos/tailscale-serve.json << 'EOF'
{
  "version": "0.0.1",
  "services": {
    "svc:web-server": {
      "endpoints": {
        "tcp:80": "https://localhost:3000"
      }
    }
  }
}
EOF

    '';
  };

  # ===== Módulo Incus embutido =====
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    agent.enable = true;

    preseed = {
      storage_pools = [
        {
          name = "default";
          driver = "dir";
        }
      ];

      networks = [ ];

      profiles = [
        {
          name = "default";
          devices = {
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }

        {
          name = "microk8s";
          config = {
            "boot.autostart" = "true";
            "security.nesting" = "true";
            "security.privileged" = "true";
            "linux.kernel_modules" = "ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,nf_nat,overlay,br_netfilter";

            "raw.lxc" = ''
              lxc.apparmor.profile = unconfined
              lxc.apparmor.allow_nesting = 1
              lxc.cap.drop=
              lxc.mount.auto=proc:rw sys:rw
            '';

            "user.user-data" = cloudInitConfig;
            "user.network-config" = networkConfig;
          };
          devices = {
            kmsg = {
              path = "/dev/kmsg";
              source = "/dev/kmsg";
              type = "unix-char";
            };
            eth0 = {
              name = "eth0";
              nictype = "bridged";
              parent = "br0";
              type = "nic";
              "security.ipv4_filtering" = false;
              "security.mac_filtering" = false;
            };
          };
        }
      ];
    };
  };

  systemd.services.init-incus-ocnix8s = {
    description = "Garante a existencia e execucao do container MicroK8s ocnix8s";

    after = [
      "incus.service"
      "incus-preseed.service"
      "network-online.target"
    ];
    wants = [
      "incus.service"
      "incus-preseed.service"
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    script = ''
      if ! ${pkgs.incus}/bin/incus info ocnix8s >/dev/null 2>&1; then
        echo "Container ocnix8s nao encontrado. Criando de forma declarativa..."
        ${pkgs.incus}/bin/incus launch images:ubuntu/26.04/cloud ocnix8s -p default -p microk8s
      else
        echo "Container ocnix8s ja existe. Garantindo que ele esteja rodando..."
        ${pkgs.incus}/bin/incus start ocnix8s || true
      fi
      sleep 5
      ${pkgs.incus}/bin/incus exec ocnix8s -- ip addr add 10.10.10.2/24 dev eth0 || true
      ${pkgs.incus}/bin/incus exec ocnix8s -- ip route add default via 10.10.10.1 || true
      ${pkgs.incus}/bin/incus exec ocnix8s -- bash -c 'chattr -i /etc/resolv.conf 2>/dev/null; echo nameserver 1.1.1.1 > /etc/resolv.conf; chattr +i /etc/resolv.conf' || true
    '';
  };

  system.stateVersion = "26.05";
}

