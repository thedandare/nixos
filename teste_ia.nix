{ config, pkgs, ... }: {
  # Ativa o firewall do sistema
  networking.firewall.enable = true;
  # Permite portas específicas para testes
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
