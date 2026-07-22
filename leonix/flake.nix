{
  description = "leonix flake";

  inputs = {
    #     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixmate.url = "github:daskladas/nixmate";
    labcoat.url = "github:jhillyerd/labcoat";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  #     letta-code.url = "github:letta-ai/letta-code";
  # Track the driver source via Flake inputs
  #     rtl8851bu-src = {
  #       url = "github:kwankiu/rtl8851bu";
  #       flake = false; # This is a standard Git repository, not a flake itself
  #     };
  outputs =
    {
      self,
      nixpkgs,
      #       rtl8851bu-src,
      llm-agents,
      ...
    }@inputs:
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
            (
              {
                config,
                pkgs,
                llm-agents,
                ...
              }:
              {
                #                 _module.args = { inherit rtl8851bu-src; };
                _module.args = { };
                environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
                  (pkgs.callPackage ./prompts/runprompt.nix { })
                  pkgs.jq
                  # In your system packages:

                  claude-code
                  #     opencode
                  vessel-browser
                  openskills
                  letta-code
                  #     gemini-cli
                  #     qwen-code
                  # ... other tools
                  #     inputs.letta-code.packages.${system}.default
                ];
              }
            )
          ];
          system = "x86_64-linux";
        };
      };
    };
}
