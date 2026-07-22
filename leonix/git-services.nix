{ config, pkgs, ... }:

let
  constantes = import ./qemu-constants.nix;
  repositorio = "ubunix";
  git-service = "github.com";
  git-user = "thedandare";
in
{
  # Um único serviço focado apenas em manter a sua pasta de emuladores atualizada
  systemd.services.git-sync-emulators = {
    description = "Sincronizador de Repositórios Git";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      cd ${constantes.HOME}
      echo ${repositorio}
            if [ ! -d "${repositorio}/.git" ]; then
                echo "📂 Pasta .git não encontrada ou inválida."
                 if [ ! -d "${repositorio}" ]; then
                     echo "📂 Pasta ${repositorio} ainda nao existe"
                      mkdir -p ${repositorio}
                  else
                      echo "📂 Pasta ${repositorio} foi encontrada mas é inválida (sem dir .git)"
                      PASTA_VELHA="$(echo ${repositorio}).old"
                      if [ ! -d $PASTA_VELHA  ]; then
                          mv ${repositorio}   $PASTA_VELHA
                          echo "Conteúdo anterior movido para  $PASTA_VELHA "
                      else
                          EPOCH=$EPOCHSECONDS
                          mv ${repositorio} $PASTA_VELHA.$EPOCH
                          echo "Conteúdo anterior movido para $PASTA_VELHA . $EPOCH "
                      fi
                 fi
               URL_GIT="https://${git-service}/${git-user}/${repositorio}.git"
               echo "  Clonando o repositório $URL_GIT"
                ${pkgs.git}/bin/git clone "$URL_GIT"
            else
                echo "🔄 Pasta já existe. Atualizando com 'git pull'..."
                cd "${repositorio}" || exit 1
                ${pkgs.git}/bin/git pull
            fi
    '';

    wantedBy = [ "multi-user.target" ];
  };
}