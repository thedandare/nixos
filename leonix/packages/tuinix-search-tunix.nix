{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix-search: tunix
    # tuned # Tuning Profile Delivery Mechanism for Linux # https://tuned-project.org
    # tuna # Thread and IRQ affinity setting GUI and cmd line tool # https://git.kernel.org/pub/scm/utils/tuna/tuna.git
    # python314Packages.tunit # Module for time unit types # https://bitbucket.org/massultidev/tunit
    # python313Packages.tunit # Module for time unit types # https://bitbucket.org/massultidev/tunit
    # tunwg # Secure private tunnel to your local servers # https://github.com/ntnj/tunwg
    # tuner # App to discover and play internet radio stations # https://github.com/louis77/tuner
  ];
}
