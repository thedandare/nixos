{
  description = "leonix flake";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      #       system = "x86_64-linux";
      #       pkgs = import nixpkgs {
      #         inherit system;
      #         config.allowUnfree = true;
      #       };
    in
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        leonix = nixpkgs.lib.nixosSystem {
          modules = [ ./configuration.nix ];
          system = "x86_64-linux";
        };
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];

        };
      };
    };
}
