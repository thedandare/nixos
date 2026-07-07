{ pkgs, ... }:

{

  services.endlessh.enable = true;
  services.endlessh.port = 2411;

  # 🖇️ OpenSSH
  services.openssh.enable = true;
  services.openssh.allowSFTP = true;
  services.openssh.ports = [ 2410 ];
  programs.ssh.enableAskPassword = false;
  services.openssh.generateHostKeys = false;
  services.openssh.hostKeys = [
    # Ao menos uma chave privada desta deve ter sido provisionada.
    # As permissões devem estar corretas senão trava. (usei 0600)
    {
      path = "/home/leo/.ssh/tdd_id_ed25519";
      type = "ed25519";
    }

    {
      path = "/home/leo/.ssh/root_id_ed25519";
      type = "ed25519";
    }

    {
      path = "/home/leo/.ssh/id_ed25519";
      type = "ed25519";
    }
  ];
  services.openssh.extraConfig = "";
  #   services.openssh.extraConfig = "PermitRootLogin yes";

  /*
    =========================================================================
    COMPARATIVO DE SEGURANÇA: FAIL2BAN vs SSHGUARD
    =========================================================================

    | Critério          | Fail2ban 🐍                                | SSHGuard ⚡                               |
    |-------------------|--------------------------------------------|--------------------------------------------|
    | Linguagem / Base  | Escrito em Python (consome mais memória).  | Escrito em C (extremamente leve e rápido). |
    | O que protege?    | Qualquer serviço (SSH, NGINX, WordPress).  | Focado principalmente em SSH.              |
    | Leitura de Logs   | Varre arquivos de texto usando Regex.      | Lê logs binários do systemd-journald.      |
    | Ações Extras      | Envia e-mails, roda scripts extras.        | Não envia e-mails nativos (só firewall).   |
    | Configuração      | Complexa, exige regras Regex longas.       | Minimalista e declarativa no NixOS.        |

    =========================================================================
    RESUMO DO VEREDITO:
    =========================================================================
    - Escolha o FAIL2BAN se precisar proteger aplicações Web (como NGINX ou
      Apache) e se o envio nativo de e-mails detalhados for indispensável.
    - Escolha o SSHGUARD se o objetivo for proteger apenas o SSH em uma
      máquina enxuta, priorizando desempenho de CPU e baixo uso de memória.

    Nota: Não use ambos monitorando o SSH ao mesmo tempo para evitar conflitos
    de regras concorrentes no Firewall (nftables/iptables).
    =========================================================================
  */

  services.sshguard = {
    # SSHGuard [https://sshguard.net/] protects hosts from brute-force.
    #
    #1 Monitoring system logs
    #2 Detecting attacks
    #3 Blocking attackers using a firewall
    enable = true;
    attack_threshold = 5; # Block attackers when their cumulative attack score exceeds threshold. Most attacks have a score of 10. Defaults to 30.
    detection_time = 1800; # Defaults to 1800. Remember potential attackers for up to detection_time seconds before resetting their score.
    blacklist_threshold = 120; # Defaults to null. Blacklist an attacker when its score exceeds threshold.
    blocktime = 60; # 5 minutos para o primeiro bloqueio

    whitelist = [
      "0.0.0.0/0"
      "10.10.0.0/16"
      "192.168.1.0/24"
      "192.168.2.0/24"
      "100.100.0.0/16"
    ];
    /*
        1️⃣ Ingestion: SSHGuard monitors system log files and journal logs. It can work with multiple log sources, including: cockpit,Common Log Format,macOS log,metalog,multilog,raw log files,syslog,syslog-ng,systemd journal

        2️⃣ Attack Detecton: SSHGuard parses logs for recognized attacks. Unlike other brute-force blockers, SSHGuard's parser is: a) Fast (Attack signatures are compiled into a full lexical analyzer which does not slow down when more signatures are added) b) Sandboxed (runs as a separate, unprivileged, and sandboxed (where supported) process)
        c) Secure.( It is not susceptible to regular expression denial of service (ReDoS) attacks because signatures are compiled into a deterministic finite-state machine that does not exhibit unbounded behavior even with specially crafted inputs)

        3️⃣ SSHGuard blocks repeat attackers using one of many firewall backends, including: firewalld, netfilter/iptables, netfilter/ipset in Linux, hosts.allow is the fallback. SSHGuard doesn't lock you out. By default, attackers are unblocked after a certain amount of time. But if you chose, you can configure blacklisting to block attackers permanently.
    */
  };

  # Cria um serviço em segundo plano focado em monitorar e notificar os bloqueios
  systemd.services.sshguard-notifier = {
    description = "Disparador de alertas por e-mail para bloqueios do SSHGuard";
    after = [ "sshguard.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
            # O journalctl filtra em tempo real as mensagens do SSHGuard que confirmam um banimento
            journalctl -u sshguard.service -f -n 0 | while read -r linha; do

              # Procura pelo padrão padrão do SSHGuard quando ele bloqueia um IP
              if echo "$linha" | grep -q "Blocking"; then

                # Extrai o IP e o score/motivo usando awk de forma segura
                IP=$(echo "$linha" | awk -F'Blocking ' '{print $2}' | awk '{print $1}')

                # Monta e despacha o e-mail via Sendmail/Postfix local
                mail -s "[SSHGuard] IP Bloqueado no Servidor: $IP" \
                     -a "From: SSHGuard Alert <sshguard@seu-servidor.com>" \
                     thedandare@gmail.com <<EOF
      Olá Administrador,

      O SSHGuard detectou um ataque de força bruta e gerou um bloqueio.

      Linha do log original:
      $linha

      O tráfego vindo de $IP foi totalmente descartado no firewall do NixOS.
      EOF
              fi
            done
    '';
  };

  #
  # 1. Habilita e configura o serviço do Fail2ban de forma global
  services.fail2ban = {
    enable = false;

    # Quantidade de tentativas permitidas (maxretry)
    maxretry = 3;

    # Tempo de banimento (aceita strings legíveis como "1h", "10m", "1d")
    bantime = "1h";

    # Whitelist: IPs ou redes locais que NUNCA serão bloqueados
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
      "192.168.1.0/24" # Sua rede local (ajuste se necessário)
    ];

    # 2. Configurações customizadas das Jails (ex: SSH e e-mail)
    jails = {
      # Customizando a jail padrão do SSH
      sshd.settings = {
        enabled = true;
        backend = "systemd"; # Usa o journald do NixOS para monitorar logs
        mode = "aggressive"; # Detecta mais padrões de ataques de força bruta
      };

      # Configuração Global de E-mail passada diretamente para o jail.local interno
      DEFAULT.settings = {
        # Configura o tipo de ação para banir e enviar e-mail com logs anexados
        action = "%(action_mwl)s";

        # Dados de envio (Mesma lógica do Postfix/Sendmail vistos anteriormente)
        destemail = "seu-email@exemplo.com";
        sender = "fail2ban@seu-servidor.com";
        mta = "sendmail";
      };
    };
  };

}
