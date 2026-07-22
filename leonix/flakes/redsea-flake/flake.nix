{
  description = "Decodificador FM-RDS Redsea (Versão Master)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "redsea";
          version = "master"; # Usando a versão mais recente do código

          src = pkgs.fetchFromGitHub {
            owner = "windytan";
            repo = "redsea";
            rev = "master";
            # HASH VAZIO INTENCIONAL: O Nix vai dar erro e mostrar o hash certo.
            # Copie o hash que aparecer no erro e cole aqui dentro das aspas!
            sha256 = "sha256-lWgjgDnnaTE732svydo8Z80ju83e1M+9xTB5ion5Zn8=";
          };

          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
          ];

          buildInputs = with pkgs; [
            libsndfile
            liquid-dsp
            nlohmann_json
          ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
        };
      }
    );
}
