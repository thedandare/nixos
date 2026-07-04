{ pkgs, ... }:
let
  # Criando o pacote lettactl a partir do NPM de forma declarativa
  lettactl = pkgs.buildNpmPackage rec {
    pname = "lettactl";
    version = "1.0.7"; # Substitua pela versão desejada do NPM

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/lettactl/-/lettactl-1.0.7.tgz";
      # Deixe o hash vazio na primeira execução para o Nix gerar o hash correto para você
      hash = "sha256-bxNljst9CPG/jnVm0bNAkruw30fZRbDn2DF1PWeydE4=";
    };
    # Esse comando roda logo após descompactar o tarball, criando o lockfile exigido
    postPatch = ''
      npm i --package-lock-only
    '';

    # O Nix precisa do hash dos pacotes dependentes (node_modules)
    # Deixe vazio na primeira execução; o erro do build te dará o hash real
    npmDepsHash = "sha256-bxNljst9CPG/jnVm0bNAkruw30fZRbDn2DF1PWeydE4=";

    # Garante que o Nix não tente rodar testes do pacote se não for necessário
    dontNpmPrune = true;
  };
in
# Agora você pode injetar a variável customizada na sua lista de pacotes do sistema
{
  environment.systemPackages = with pkgs; [
    nodejs_26
    # lettactl
  ];
}
