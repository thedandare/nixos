{
  description = "leonix flake";

  inputs = {
    #     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixmate.url = "github:daskladas/nixmate";
    labcoat.url = "github:jhillyerd/labcoat";
#     letta-code.url = "github:letta-ai/letta-code";

  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        leonix = nixpkgs.lib.nixosSystem {
          # ==  hostname
          specialArgs = { inherit inputs; }; # é uma ótima prática, pois permite que os seus
          #           arquivos internos (como o seu módulo do Incus)
          #           consigam acessar os repositórios do nixmate ou
          #           labcoat diretamente se precisarem de algum pacote isolado deles.

          modules = [
            ./configuration.nix

          ];
          system = "x86_64-linux";

        };
      };
    };
}
