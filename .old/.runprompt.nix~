# runprompt.nix
{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "runprompt";
  version = "0-unstable";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/chr15m/runprompt/main/runprompt";
    hash = "sha256-gB3/04HPMhVFMQfLIAX6AL7fJS0hHfJlRKDyb97vZT0=";
    # pkgs.lib.fakeHash; # veja a nota do hash abaixo
  };

  dontUnpack = true;
  nativeBuildInputs = [ pkgs.python3 ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/runprompt
    patchShebangs $out/bin/runprompt
    runHook postInstall
  '';
}
