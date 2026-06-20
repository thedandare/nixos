{
  description = "leonix flake";

  inputs = {
    #     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
          ];
          system = "x86_64-linux";

        };
      };
    };
}
