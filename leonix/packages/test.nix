{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # TUINIX Added
    tuifeed # added by TUINIX
  ];
}
