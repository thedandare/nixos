# ▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
# ▐                            🄻🄴🄾🄽🄸🅇                                     ▌
# ▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
{
  config,
  pkgs,
  #   rtl8851bu-src,
  inputs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    sha256 = "sha256:10y7xwm4ykcs3pqyj80ri8vwgwwvzzax32f2vgpqb8qc25xv2sv4";
  };

  #   foo = builtins.getFlake (toString /home/leo/flakes/foo);
  #   myflake = builtins.getFlake (toString /home/leo/myflake);
  #   initCorsairMouse = builtins.getFlake (toString /home/leo/flakes/initCorsairMouse);
  #     /opt/nix-security-box/kubernetes.nix

  #    ./agenix.nix
  #     ./hydra.nix
in
{

  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./kernel
    ./networks
    ./packages
    ./programs
    ./services
    ./users
    ./virtualisation
  ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "08:00" ]; # Executa a varredura e unificação em background às 4h da manhã

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };

  # 🗝️ Seguranca
  security.sudo.wheelNeedsPassword = false;

  #  The following rule is the analogue of NOPASSWD:ALL in sudo, in that wheel users do not need to authenticate again when performing any action.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
  # 1. Habilita o suporte ao hardware TPM
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # Defaults to false.
  };

  /*
      O que o PKCS#11 faz (E por que você não precisa dele)
      O PKCS#11 é um padrão de computação (uma API) usado para fazer
      com que aplicativos de terceiros em espaço de usuário conversem
      diretamente com hardwares criptográficos (como chaves Yubikey,
      Smart Cards ou chips TPM).No Linux, você só ativa o módulo pkcs11
      do TPM se quiser fazer estas duas coisas específicas:Chaves SSH
      guardadas no TPM: Para que o seu terminal use a chave criptográfica
      hardware ao se conectar a um servidor via SSH.Assinatura Git/GPG ou
      certificados no Navegador: Para assinar Commits de código usando o
      hardware ou carregar certificados digitais do governo (como e-CPF)
      direto no Firefox/Chrome.

    or que o KWallet não precisa dele?O foco do seu problema é o KWallet
    deslogar suas contas. O ecossistema do KDE Plasma 6 no NixOS
    gerencia isso usando a biblioteca kwallet-pam.O fluxo de funcionamento
    dispensa o PKCS#11 porque ocorre de forma puramente local:Você
    digita a senha da sua máquina na tela do SDDM.O subsistema PAM
    do Linux intercepta essa senha e, em vez de apenas liberar o
    sistema, ele a entrega imediatamente para o arquivo de biblioteca
    kwallet-pam (módulo do KDE).
    O kwallet-pam usa essa exata string da senha para descriptografar
    e abrir a sua carteira local kdewallet de forma totalmente silenciosa
    na memória RAM.
    O Chrome, o cliente do GitHub e o Tailscale abrem, encontram a
    carteira já aberta pelo PAM e puxam os seus respectivos tokens
    do Gmail e sessões sem disparar nenhum aviso na tela.
  */

  # 2. Configuração correta do PAM para o KWallet no Plasma 6 / Unstable
  security.pam.services = {
    # Vincula o desbloqueio ao SDDM (Gerenciador de Login do KDE)
    sddm = {
      kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam; # Sintaxe do Plasma 6
      };
    };

    #     # Garante que o bloqueador de tela (KScreenLocker) não trave sua carteira ao retornar
    #     kde = {
    #       kwallet = {
    #         enable = true;
    #         package = pkgs.kdePackages.kwallet-pam;
    #       };
    #     };
  };
  # 2. Configura o SUDO para não pedir senha para o seu usuário (Método Direto)
  # Já que você odeia digitação, isso resolve o sudo sem precisar interagir com o hardware
  security.sudo.extraRules = [
    {
      users = [ "leo" ]; # Substitua pelo seu nome de usuário
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Isolamento estrito dos builds para reprodutibilidade e segurança
  nix.settings.sandbox = true; # defaults true. Use "relaxed" APENAS se: Você for um desenvolvedor de pacotes avançado e estiver criando ferramentas próprias que obrigatoriamente precisem interagir com a rede ou hardware bruto durante a fase de build (como testes de integração de rede complexos).

  #   # 3. Desbloqueio automático de Wallets/Keyrings com PAM e TPM
  #   security.pam.services.login.text = ''
  #     auth optional pam_gnome_keyring.so
  #     session optional pam_gnome_keyring.so auto_start
  #   '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Sao_Paulo";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  system.stateVersion = "25.11"; # 🚭 No Changing.

}
