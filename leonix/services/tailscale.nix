{ ... }:
{

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = "../secret/tailscale_key";
    serve = {
      enable = true;

      configFile = "/opt/secrets/tailscale-serve.json";

    };
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}
