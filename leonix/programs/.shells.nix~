{ ... }:
{
  # 1. Enable Zsh system-wide
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true; # Enable compatibility with bash’s programmable completion system.
    #     shellInit = "[[ -o interactive ]] && echo -e \" \033[7;33m E aízsh \033[0m\" "; # Shell script code called during zsh shell initialisation.
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell"; # <--- ADICIONE ESTA LINHA (O robbyrussell mostra o caminho atual por padrão)
      #       preLoaded = "[[ -o interactive ]] && echo -e \"'\033[7;31m' oh My Zsh  '\033[0m'\"";
      plugins = [
        "zsh-interactive-cd"
        "web-search"
        # ... resto dos seus plugins
        "branch"
        #         "catimg"
        "chezmoi"
        "colorize"
        "command-not-found"
        "common-aliases"
        "dirhistory"
        "dirpersist"
        "docker"
        #         "emoji"
        "fasd"
        #         "fbterm"
        "flutter"
        "gcloud"
        "helm"
        "history-substring-search"
        "hitchhiker"
        "kate"
        "kompose"
        "kubectl"
        "last-working-dir"
        "microk8s"
        "rsync"
        #         "ssh-agent"
        "systemadmin"
        "systemd"
        "tailscale"
        "terraform"
        #         "thefuck" # Press ESC twice to correct previous console command. (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/thefuck)
        "z"
        "zoxide"

      ];
    };
    setOptions = [
      "AUTO_CD" # if a command isn't valid, but is a directory, cd to that dir
      "AUTO_PUSHD" # make cd push the old directory onto the directory stack
      "BASH_AUTO_LIST" # https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories
      "GLOB_COMPLETE" # When the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion and cycle through them like MENU_COMPLETE.
      "MENU_COMPLETE" # On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately. Then when completion is requested again, remove the first match and insert the second match, etc. When there are no more matches, go back to the first one again
      "REC_EXACT" # If the string on the command line exactly matches one of the possible completions, it is accepted, even if there is another completion (i.e. that string with something else added) that also matches.
      "APPEND_HISTORY" # Zsh sessions will append their history list to the history file, rather than replace it. Thus, multiple parallel zsh sessions will all have the new entries from their history lists added to the history file, in the order that they exit.
      "HIST_EXPIRE_DUPS_FIRST" # If the internal history needs to be trimmed to add the current command line, setting this option will cause the oldest history event that has a duplicate to be lost before losing a unique event from the list
      "HIST_FCNTL_LOCK" # When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.
      "HIST_FIND_NO_DUPS" # When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous.
      "HIST_LEX_WORDS" # By default, shell history that is read in from files is split into words on all white space. This means that arguments with quoted whitespace are not correctly handled, with the consequence that references to words in history lines that have been read from a file may be inaccurate. When this option is set, words read in from a history file are divided up in a similar fashion to normal shell command line handling. Although this produces more accurately delimited words, if the size of the history file is large this can be slow. Trial and error is necessary to decide.
      "HIST_REDUCE_BLANKS" # Remove superfluous blanks from each command line being added to the history list.
      "SHARE_HISTORY" # This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file (the latter is like specifying INC_APPEND_HISTORY, which should be turned off if this option is in effect). The history lines are also output with timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where we left off reading the file after it gets re-written).
      # By default, history movement commands visit the imported lines as well as the local lines, but you can toggle this on and off with the set-local-history zle binding. It is also possible to create a zle widget that will make some commands ignore imported commands, and some include them.
      # If you find that you want more control over when commands get imported, you may wish to turn SHARE_HISTORY off, INC_APPEND_HISTORY or INC_APPEND_HISTORY_TIME (see above) on, and then manually import commands whenever you need them using ‘fc -RI’
      "CORRECT" # Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL option is not set or when some directories in the path are not readable, this may falsely report spelling errors the first time some commands are used.
      "CORRECT_ALL" # Try to correct the spelling of all arguments in a line.
      "INTERACTIVE_COMMENTS" # Allow comments even in interactive shells.

      "PUSHD_IGNORE_DUPS"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
    ];

    # Global Shell Aliases
    shellAliases = {
      ll = "ls -l";
      B = "sudo nixos-rebuild switch";
      vim = "nvim";
      vi = "nvim";

    };

    # Equivalent to global .zshrc
    interactiveShellInit = ''
                #       eval "$(zoxide init zsh --cmd cd)"
                # Adiciona ou atualiza aliases NixOS em /etc/nixos/users/env.nix
                # Uso:
                #   nixa ll "ls -lah"
                #   nixa gst "git status"
                #   nixa rebuild "sudo nixos-rebuild switch --show-trace"F
                #
                # Também aceita:
                #   nixa ll=ls -lah
                #
                nixa() {
                  local file="/etc/nixos/users/env.nix"

                  if [ "$#" -lt 2 ]; then
                    echo "Uso:"
                    echo "  nixa NOME COMANDO..."
                    echo "  nixa ll \"ls -lah\""
                    echo "  nixa gst \"git status\""
                    return 1
                  fi

                  local name cmd

                  # Forma: nixa ll=ls -lah
                  if [[ "$1" == *=* ]]; then
                    name="''${1%%=*}"
                    cmd="''${1#*=}"
                    shift
                    if [ "$#" -gt 0 ]; then
                      cmd="$cmd $*"
                    fi
                  else
                    name="$1"
                    shift
                    cmd="$*"
                  fi

                  if [ -z "$name" ] || [ -z "$cmd" ]; then
                    echo "Erro: nome e comando são obrigatórios."
                    return 1
                  fi

                  if [ ! -f "$file" ]; then
                    echo "Erro: arquivo não encontrado: $file"
                    return 1
                  fi

                  sudo cp "$file" "$file.bak.$(date +%Y%m%d-%H%M%S)"
       local cmd_escaped="$cmd"
      cmd_escaped="''${cmd_escaped//\\/\\\\}"
      cmd_escaped="''${cmd_escaped//\"/\\\"}"
      cmd_escaped="''${cmd_escaped//\$\{/\\\$\{}"

      sudo awk -v name="$name" -v cmd="$cmd_escaped" '
        BEGIN {
          in_aliases = 0
          added = 0
          new_line = "    \"" name "\" = \"" cmd "\";"
        }

        /environment\.shellAliases[[:space:]]*=[[:space:]]*\{/ {
          in_aliases = 1
          print
          next
        }

        in_aliases && $0 ~ "^[[:space:]]*\"?" name "\"?[[:space:]]*=" {
          next
        }

        in_aliases && /^[[:space:]]*\};/ {
          print new_line
          in_aliases = 0
          added = 1
          print
          next
        }

        { print }

        END {
          if (!added) {
            exit 2
          }
        }
      ' "$file" | sudo tee "$file.tmp" >/dev/null && sudo mv "$file.tmp" "$file"

                  if command -v nixfmt >/dev/null 2>&1; then
                    sudo nixfmt "$file"
                  fi

                  echo "Alias NixOS adicionado/atualizado:"
                  echo "  $name = $cmd"
                 if whiptail \
              --title "NixOS rebuild" \
              --yes-button "Switch now" \
              --no-button "Later" \
              --yesno "Alias added successfully.\n\nRun 'nixos-rebuild switch' now?" \
              10 60
          then
              sudo nixos-rebuild switch --show-trace
          fi
                }









    '';
  };
  #       eval "$(atuin init zsh --disable-up-arrow)"

}

# Dynamically generate 3-letter aliases for Zsh
#   programs.zsh.interactiveShellInit = ''
#     #     if [ -d /etc/nixos ]; then
#     #       for file in /etc/nixos/*; do
#     #         if [ -f "$file" ]; then
#     #           # Get filename without path (e.g., "configuration.nix")
#     #           filename=$(basename "$file")
#     #
#     #           # Remove the extension (e.g., "configuration")
#     #           clean_name="''${filename%.*}"
#     #
#     #           # Extract only the first 3 characters using Zsh substring slicing
#     #           alias_name="''${clean_name[1,3]}"
#     #
#     #           # Create the alias (e.g., alias con="nano /etc/nixos/configuration.nix")
#     #           # Replace 'nano' with your preferred editor
#     #           alias "$alias_name"="nano $file"
#     #         fi
#     #       done
#     #     fi
#   '';
