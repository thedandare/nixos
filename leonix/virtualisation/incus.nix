{ config, pkgs, ... }:

let
  # Importa a pasta e consome o default.nix de forma nativa
  segredos = import ../secret;

  incusVmProvisionerScriptRaw = builtins.readFile ./incus_vm_provision.sh;
  incusVmProvisionerScript =
    builtins.replaceStrings [ "\${pkgs.incus}" ] [ "${pkgs.incus}" ]
      incusVmProvisionerScriptRaw;

  # Lê o arquivo .yaml do disco e armazena em uma string
  cloudInitRaw = builtins.readFile ./cloud-init.yaml;

  # 💉 INJEÇÃO CIRÚRGICA: Substitui placeholders pelos valores reais dos segredos
  cloudInitConfig =
    builtins.replaceStrings
      [ "INJECT_CLIENT_ID" "INJECT_CLIENT_SECRET" ]
      [ segredos.tailscale.clientId segredos.tailscale.clientSecret ]
      cloudInitRaw;

  #   networkConfig = builtins.readFile ./network-config.yaml;
  #             "user.network-config" = networkConfig;

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

      networks = [ ];

      profiles = [
        {
          name = "default";

        }

        #         rbd,
        #           modules = {
        #               path = "/lib/modules";
        #               source = "${config.system.modulesTree}/lib/modules";
        #               type = "disk";
        #               readonly/. = "true";
        #             };
        {
          name = "microk8s";
          # CORRIGIDO: Força o mapeamento relativo na árvore nativa do cgroup v2 do Kernel 7

          config = {
            "boot.autostart" = "true";
            "security.nesting" = "true";
            "security.privileged" = "true";
            "linux.kernel_modules" = "rbd,ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,nf_nat,overlay,br_netfilter";

            "raw.lxc" = ''
              lxc.apparmor.profile = unconfined
              lxc.apparmor.allow_nesting = 1
              lxc.cap.drop=
              lxc.mount.auto=proc:rw sys:rw
            '';

            "user.user-data" = cloudInitConfig;

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
  # #                 lxc.mount.auto = cgroup:rw:force

  # Cria um serviço Systemd para gerenciar a existência do container leonk8s
  systemd.services.init-incus-leonks = {
    description = "Garante a existencia e execucao dos containers leonk7s leonk8s leonk9s";

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

    script = incusVmProvisionerScript;

    #     script = ''
    #       # Verifica se o container leonk8s já existe no ecossistema do Incus
    #       if ! ${pkgs.incus}/bin/incus info leonk8s >/dev/null 2>&1; then
    #         echo "Container leonk8s nao encontrado. Criando de forma declarativa..."
    #
    #         # Lança o container usando os perfis declarados no preseed
    #         ${pkgs.incus}/bin/incus launch images:ubuntu/26.04/cloud leonk8s -p default -p microk8s
    #         else
    #         echo "Container leonk8s ja existe. Garantindo que ele esteja rodando..."
    #
    #         # Se ele já existir mas estiver parado, inicia o container
    #         ${pkgs.incus}/bin/incus start leonk8s || true
    #       fi
    #     '';
  };

}
