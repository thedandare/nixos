{ config, pkgs, ... }:

let
  # Lê o arquivo .yaml do disco e armazena em uma string
  cloudInitConfig = builtins.readFile ./cloud-init.yaml;
  networkConfig = builtins.readFile ./network-config.yaml;
in
{

  # Habilita o ecossistema Incus (Sucessor do LXD no NixOS)
  virtualisation.incus = {
    enable = true;

    ui = {
      enable = true;
    };

    agent.enable = true;

    # Define a configuração declarativa do Incus (Rede, Storage e Perfis)

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
          # CORRIGIDO: Força o mapeamento relativo na árvore nativa do cgroup v2 do Kernel 7

          config =
            let
              # Importa a pasta e consome o default.nix de forma nativa
              segredos = import ../secret;
            in
            {
              "boot.autostart" = "true";
              "security.nesting" = "true";
              "security.privileged" = "true";
              "linux.kernel_modules" = "ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,nf_nat,overlay,br_netfilter";

              "raw.lxc" = ''
                lxc.apparmor.profile = unconfined
                lxc.mount.auto = cgroup:rw:force
              '';

              # 🔐 INJEÇÃO VIA BARREL DIRETO NO PRESEED
              "environment.TAILSCALE_CLIENT_ID" = segredos.tailscale.clientId;
              "environment.TAILSCALE_CLIENT_SECRET" = segredos.tailscale.clientSecret;

              "user.user-data" = cloudInitConfig;
              "user.network-config" = networkConfig;
            };
          devices = {
            kmsg = {
              path = "/dev/kmsg";
              source = "/dev/kmsg";
              type = "unix-char";
            };
            # SOBRESCREVE A ETH0: Pluga o container direto na sua bridge br0 do QEMU/NixOS
            eth0 = {
              name = "eth0";
              nictype = "bridged";
              parent = "br0";
              type = "nic";
              # Permite que os IPs internos dos Pods trafeguem pela bridge br0 do host
              "security.ipv4_filtering" = false;
              "security.mac_filtering" = false;
            };
          };

        }
      ];

    };
  };

  # Lembrar de adicionar seu usuário aos grupos "incus-admin" e "incus" em users.nix

  # Cria um serviço Systemd para gerenciar a existência do container thmbk8s
  systemd.services.init-incus-thmbk8s = {
    description = "Garante a existencia e execucao do container MicroK8s thmbk8s";

    # Garante que o serviço só rode DEPOIS que o Incus e a rede estiverem prontos
    after = [
      "incus.service"
      "incus-preseed.service"
      "network.target"
    ];
    wants = [
      "incus.service"
      "incus-preseed.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false; # Evita que o serviço rode novamente em cada boot se já deu certo
    };

    script = ''
      # Verifica se o container thmbk8s já existe no ecossistema do Incus
      if ! ${pkgs.incus}/bin/incus info thmbk8s >/dev/null 2>&1; then
        echo "Container thmbk8s nao encontrado. Criando de forma declarativa..."

        # Lança o container usando os perfis declarados no preseed
        ${pkgs.incus}/bin/incus launch images:ubuntu/26.04/cloud thmbk8s -p default -p microk8s
        else
        echo "Container thmbk8s ja existe. Garantindo que ele esteja rodando..."

        # Se ele já existir mas estiver parado, inicia o container
        ${pkgs.incus}/bin/incus start thmbk8s || true
      fi
    '';
  };

}

# Long lived token microk8s join 100.100.1.16:25000/ed5e596a1985064b0abf9782e0f6a73d/dbefc529577c

# # NAO FUNCIONA!
# systemd.services.incus = {
#     environment = {
#       TMPDIR = "/var/tmp/incus";
#     };
#     serviceConfig = {
#       # Libera explicitamente a gravação e leitura nessa pasta dentro do sandbox do Systemd
#       ReadWritePaths = [ "/var/tmp/incus" ];
#     };
#   };
#
#   # Mantém a criação da pasta no boot com as permissões corretas
#   systemd.tmpfiles.rules = [
#     "d /var/tmp/incus 1777 root root 3d"
#   ];
/*
  systemd.services.incus = {
    # Define o diretório temporário apontando para o espaço de runtime oficial do serviço
    environment = {
      TMPDIR = "/run/incus";
    };

    serviceConfig = {
      # Cria automaticamente a pasta /run/incus-tmp no boot com permissão correta
      #       RuntimeDirectory = "incus-tmp";
      #       RuntimeDirectoryMode = "1777";

      # Desativa os isolamentos de arquivos temporários que geram o erro original
      PrivateTmp = false;

      # Permite explicitamente a leitura e escrita do serviço nesse caminho global de runtime
      ReadWritePaths = [ "/run/incus" ];
    };
  };

  # OBRIGATÓRIO: Garante as permissões e as ACLs corretas na pasta pai no boot
  systemd.tmpfiles.rules = [
    # 1. Cria a pasta dando direito de leitura e travessia global (755)
    "d /run/incus 0755 root root -"

    # 2. Força uma ACL padrão: QUALQUER arquivo criado aqui dentro nascerá
    # permitindo leitura (r) para QUALQUER usuário do sistema (incluindo o container)
    "A+ /run/incus - - - - default:other:r--"
  ]
*/

# Remova a regra antiga do systemd.tmpfiles.rules do /tmp ou /var/tmp se ainda estiver lá
