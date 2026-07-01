{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = [
    pkgs.python3
    pkgs.uv
  ];

  env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.libz
  ];

  shellHook = ''
          if [ -d ".venv" ]; then
            echo "Ambiente virtual localizado."
          else
            echo "Criando ambiente virtual isolado com UV..."
            uv venv
          fi
          source .venv/bin/activate

          echo "Garantindo que o google-adk e suas dependências estão atualizados..."
          uv pip install -q -U google-adk

          if [ -f /etc/nixos/secret/google.env ]; then
            echo "Carregando chaves de API de ../secret/google.env..."
    #         export $(cat ../secret/google.env | xargs)
            cp /etc/nixos/secret/google.env .env
          else
            echo "Erro: Arquivo ../secret/google.env não encontrado!"
          fi

          echo "Pronto! Usando 'adk web --port 8000' para iniciar o servidor."
        adk web --port 8000
  '';
}
