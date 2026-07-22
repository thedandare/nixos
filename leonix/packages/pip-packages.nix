{
  pkgs ? import <nixpkgs> { },
}:

let
  google-adk = pkgs.python3Packages.buildPythonPackage rec {
    pname = "google-adk";
    version = "2.3.0";

    pyproject = true;

    src = pkgs.python3Packages.fetchPypi {
      pname = "google_adk";
      inherit version;
      hash = "sha256-S5XJmGWpprVuir09O4FpNfDbHOu+8yhzaiabZTe9Hfc=";
    };

    nativeBuildInputs = with pkgs.python3Packages; [
      flit-core
      setuptools
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      aiosqlite
      authlib
      click
      fastapi
      google-auth
      google-genai
      graphviz
      httpx
      jsonschema
      opentelemetry-api
      opentelemetry-sdk
      packaging
      pydantic
      python-dotenv
      python-multipart
      pyyaml
      requests
      starlette
      tenacity
      typing-extensions
      tzlocal
      uvicorn
      watchdog
      websockets
    ];

    dontCheckRuntimeDeps = true;
    doCheck = false;
    catchConflicts = false;

  };

  pythonComAdk = pkgs.python3.withPackages (ps: [
    google-adk
  ]);

in
pkgs.mkShell {
  packages = [
    pythonComAdk
  ];

  env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.libz
  ];

  # Busca a chave automaticamente na sua pasta de segredos
  shellHook = ''
    if [ -f /etc/nixos/secret/google.env ]; then
      echo "Carregando chaves de API de ../secret/google.env..."
      export $(cat ../secret/google.env | xargs)
    else
      echo "Erro: Arquivo ../secret/google.env não encontrado!"
    fi
  '';
}
