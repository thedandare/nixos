{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix-search: tui
    # tuir # Browse Reddit from your Terminal (fork of rtv) # https://gitlab.com/Chocimier/tuir
    # tuist # Command line tool that helps you generate, maintain and interact with Xcode projects # https://tuist.dev
    # tuios # Terminal-based window manager # https://github.com/Gaurav-Gosain/tuios
    # tuicr # Review AI-generated diffs like a GitHub pull request, right from your terminal # https://tuicr.dev
    # tuisky # TUI client for bluesky # https://github.com/sugyan/tuisky
    # tuicam # Terminal-based camera with switchable modes # https://github.com/hlsxx/tuicam
  ];
}
