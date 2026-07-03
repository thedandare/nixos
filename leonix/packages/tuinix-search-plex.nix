{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix-search: plex
    # plex # Media library streaming server # https://plex.tv/
    # plexamp # Beautiful Plex music player for audiophiles, curators, and hipsters # https://plexamp.com/
    # plexRaw # Media library streaming server # https://plex.tv/
    # fpc # Free Pascal Compiler from a source distribution # https://www.freepascal.org
    # plex-htpc # Plex HTPC client for the big screen # https://plex.tv/
  ];
}
