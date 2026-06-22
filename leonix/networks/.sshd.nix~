{ pkgs, ... }:

{
  # 🖇️ OpenSSH
  services.openssh.enable = true;
  services.openssh.allowSFTP = true;
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
      path = "/home/leo/.ssh/leo.ssh";
      type = "ed25519";
    }

    {
      path = "/home/leo/.ssh/id_ed25519";
      type = "ed25519";
    }
  ];
  services.openssh.extraConfig = "PermitRootLogin yes";
  services.openssh.startWhenNeeded = true;

  services.sshguard = {
    # SSHGuard [https://sshguard.net/] protects hosts from brute-force.
    #
    #1 Monitoring system logs
    #2 Detecting attacks
    #3 Blocking attackers using a firewall
    enable = true;
    attack_threshold = 20; # Block attackers when their cumulative attack score exceeds threshold. Most attacks have a score of 10. Defaults to 30.
    detection_time = 1800; # Defaults to 1800. Remember potential attackers for up to detection_time seconds before resetting their score.
    blacklist_threshold = 120; # Defaults to null. Blacklist an attacker when its score exceeds threshold.
    whitelist = [
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
}
