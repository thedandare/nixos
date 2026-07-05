#!/usr/bin/env bash
#
# TUINIX YAD - GTK/mouse edition
#
# Reads one or more .nix files, finds simple package entries inside:
#
#   environment.systemPackages = with pkgs; [
#     foo
#     # bar
#   ];
#
# and lets you enable/disable them with a GTK checklist powered by YAD.
#
# Requirements:
#   - bash 4+
#   - yad
#   - awk, sed, diff
# Optional:
#   - git       local history / commits
#   - xdg-open  open search.nixos.org pages
#
# Usage:
#   ./tuinix_yad.sh file1.nix file2.nix
#   ./tuinix_yad.sh
#   TUINIX_GIT_AUTO_INIT=1 ./tuinix_yad.sh
#
# Notes:
#   - This parser is intentionally conservative. It edits simple package lines
#     only. Complex expressions and multiline package definitions are ignored.
#   - All changes remain in memory until Save.
#   - Save creates .bak and .bak.YYYYMMDD-HHMMSS backups.
#   - Git support initializes a local repo for the current folder and can create
#     baseline/update commits for the .nix files managed by TUINIX.
#

set -Euo pipefail

TUINIX_NAME="TUINIX"
TUINIX_VERSION="3.0.0-yad"
TUINIX_TMPDIR=""
TUINIX_BACKUP_SUFFIX=".bak"
TUINIX_NIXOS_CHANNEL="${TUINIX_NIXOS_CHANNEL:-26.05}"
TUINIX_WIDTH="${TUINIX_WIDTH:-1200}"
TUINIX_HEIGHT="${TUINIX_HEIGHT:-760}"
TUINIX_GIT_ROOT="${TUINIX_GIT_ROOT:-$PWD}"
TUINIX_GIT_AUTO_INIT="${TUINIX_GIT_AUTO_INIT:-0}"
TUINIX_GIT_AUTO_COMMIT="${TUINIX_GIT_AUTO_COMMIT:-0}"
TUINIX_LAST_STATUS=""
TUINIX_DEBUG="${TUINIX_DEBUG:-0}"

FILES=()

REC_FILE=()
REC_LINE=()
REC_SECTION=()
REC_PKG=()
REC_ENABLED_ORIG=()
REC_ENABLED=()
REC_ORIG_TEXT=()
REC_META=()

declare -A LINE_TO_REC=()
declare -A FILE_TOTAL=()
declare -A FILE_ACTIVE=()
declare -A FILE_DIRTY=()
declare -A SECTION_TOTAL=()
declare -A SECTION_ACTIVE=()
declare -A SECTION_DIRTY=()
declare -A FILE_INDEX=()

# -----------------------------------------------------------------------------
# Basics
# -----------------------------------------------------------------------------

main() {
  init_runtime
  parse_args_and_files "$@"
  require_dependencies
  parse_workspace
  maybe_offer_git_init
  yad_main_loop
}

init_runtime() {
  TUINIX_TMPDIR="$(mktemp -d -t tuinix-yad.XXXXXX)"
  trap cleanup EXIT
}

cleanup() {
  local code=$?
  [[ -n "${TUINIX_TMPDIR:-}" && -d "${TUINIX_TMPDIR:-}" ]] && rm -rf -- "$TUINIX_TMPDIR"
  exit "$code"
}

die() {
  printf 'TUINIX error: %s\n' "$*" >&2
  exit 1
}

warn() {
  printf 'TUINIX warning: %s\n' "$*" >&2
}

debug() {
  [[ "$TUINIX_DEBUG" == "1" ]] && printf 'DEBUG: %s\n' "$*" >&2
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

trim() {
  local s="$*"
  s="${s#"${s%%[!$' \t\r\n']*}"}"
  s="${s%"${s##*[!$' \t\r\n']}"}"
  printf '%s' "$s"
}

basename_safe() {
  basename -- "$1"
}

abspath() {
  local p="$1"
  if has_cmd realpath; then
    realpath -- "$p"
  elif has_cmd readlink; then
    readlink -f -- "$p" 2>/dev/null || printf '%s\n' "$p"
  else
    case "$p" in
      /*) printf '%s\n' "$p" ;;
      *) printf '%s/%s\n' "$PWD" "$p" ;;
    esac
  fi
}

relpath_from_git_root() {
  local p="$1"
  if has_cmd realpath; then
    realpath --relative-to="$TUINIX_GIT_ROOT" -- "$p" 2>/dev/null || printf '%s\n' "$p"
  else
    printf '%s\n' "$p"
  fi
}

require_dependencies() {
  if ! has_cmd yad; then
    cat >&2 <<'MSG'
TUINIX YAD edition requires `yad`, but it was not found in PATH.

On Nix/NixOS, try:

  nix shell nixpkgs#yad

or add `yad` to environment.systemPackages.
MSG
    exit 127
  fi
  has_cmd awk || die "awk is required"
  has_cmd sed || die "sed is required"
  has_cmd diff || warn "diff not found; diff view will use git diff if available"
}

parse_args_and_files() {
  FILES=()
  if [[ $# -gt 0 ]]; then
    local arg f
    for arg in "$@"; do
      if [[ -d "$arg" ]]; then
        while IFS= read -r -d '' f; do
          FILES+=("$(abspath "$f")")
        done < <(find "$arg" -maxdepth 1 -type f -name '*.nix' -print0 | sort -z)
      else
        [[ -f "$arg" ]] || die "file not found: $arg"
        FILES+=("$(abspath "$arg")")
      fi
    done
  else
    local f
    while IFS= read -r -d '' f; do
      FILES+=("$(abspath "$f")")
    done < <(find . -maxdepth 1 -type f -name '*.nix' -print0 | sort -z)
  fi

  [[ ${#FILES[@]} -gt 0 ]] || die "no .nix files found"

  local i
  for i in "${!FILES[@]}"; do
    FILE_INDEX["${FILES[$i]}"]="$i"
  done
}

# -----------------------------------------------------------------------------
# Parser
# -----------------------------------------------------------------------------

reset_workspace() {
  REC_FILE=()
  REC_LINE=()
  REC_SECTION=()
  REC_PKG=()
  REC_ENABLED_ORIG=()
  REC_ENABLED=()
  REC_ORIG_TEXT=()
  REC_META=()
  LINE_TO_REC=()
  FILE_TOTAL=()
  FILE_ACTIVE=()
  FILE_DIRTY=()
  SECTION_TOTAL=()
  SECTION_ACTIVE=()
  SECTION_DIRTY=()
}

parse_workspace() {
  reset_workspace
  local file
  for file in "${FILES[@]}"; do
    parse_file "$file"
  done
  rebuild_stats
}

parse_file() {
  local file="$1"
  local line_no=0
  local inside=0
  local waiting_for_bracket=0
  local current_section="General"
  local line

  while IFS= read -r line || [[ -n "$line" ]]; do
    ((line_no++)) || true

    if [[ "$inside" == "0" ]]; then
      if [[ "$line" =~ environment[.]systemPackages ]]; then
        waiting_for_bracket=1
        if [[ "$line" == *"["* ]]; then
          inside=1
          waiting_for_bracket=0
        fi
      elif [[ "$waiting_for_bracket" == "1" && "$line" == *"["* ]]; then
        inside=1
        waiting_for_bracket=0
      fi
      continue
    fi

    if list_ends_here "$line"; then
      inside=0
      waiting_for_bracket=0
      current_section="General"
      continue
    fi

    local maybe_section
    maybe_section="$(extract_section_name "$line" || true)"
    if [[ -n "$maybe_section" ]]; then
      current_section="$maybe_section"
      continue
    fi

    local pkg enabled meta
    if parsed_package_line "$line" pkg enabled meta; then
      add_record "$file" "$line_no" "$current_section" "$pkg" "$enabled" "$line" "$meta"
    fi
  done < "$file"
}

list_ends_here() {
  local s
  s="$(trim "$1")"
  [[ "$s" =~ ^\] ]]
}

extract_section_name() {
  local line="$1"
  local s content cleaned words deco

  [[ "$line" =~ ^[[:space:]]*# ]] || return 1
  s="${line#"${line%%[![:space:]]*}"}"
  s="${s#\#}"
  content="$(trim "$s")"
  [[ -n "$content" ]] || return 1

  case "$content" in
    http*|https*|c.f:*|cf:*|c.f*|Programs\ provided:*|Programas\ fornecidos:* ) return 1 ;;
  esac
  [[ "$content" == *"://"* ]] && return 1
  [[ "$content" =~ ^(It|For|The|This|A|An|and|or|to|from)[[:space:]] ]] && return 1
  [[ "$content" =~ ^[[:space:]]*[🔧🔩] ]] && return 1

  # A lowercase single token in a comment is usually a disabled package, not a title.
  if [[ "$content" =~ ^[a-z0-9_][A-Za-z0-9_.+-]*([[:space:]]*(#.*)?)?$ ]]; then
    return 1
  fi

  cleaned="$content"
  for deco in "▐" "▌" "▀" "▄" "█" "─" "━" "═" "║" "╔" "╗" "╚" "╝" "╠" "╣" "╦" "╩" "╬"; do
    cleaned="${cleaned//${deco}/ }"
  done
  cleaned="$(printf '%s' "$cleaned" | sed -E \
    -e 's/[#=+*_|<>~`.,;:(){}\[\]\/\\-]+/ /g' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+$//')"

  [[ -n "$cleaned" ]] || return 1
  words="$(awk '{print NF}' <<< "$cleaned")"
  [[ "$words" -le 8 ]] || return 1
  [[ "$cleaned" == *"."* ]] && return 1

  if [[ "$content" == *"▐"* || "$content" == *"▀"* || "$content" == *"▄"* || "$content" == *"═"* || "$content" == *"─"* ]]; then
    printf '%s\n' "$cleaned"
    return 0
  fi
  if [[ "$cleaned" =~ ^[[:upper:]] || "$cleaned" =~ ^[^A-Za-z0-9] ]]; then
    printf '%s\n' "$cleaned"
    return 0
  fi
  return 1
}
parsed_package_line() {
  local line="$1"
  local __pkg="$2"
  local __enabled="$3"
  local __meta="$4"
  local s out_enabled out_pkg out_tail out_meta

  s="$line"
  s="${s#"${s%%[![:space:]]*}"}"
  [[ -n "$s" ]] || return 1

  out_enabled=1
  if [[ "$s" =~ ^#[[:space:]]?(.*)$ ]]; then
    out_enabled=0
    s="${BASH_REMATCH[1]}"
    s="${s#"${s%%[![:space:]]*}"}"
  fi

  [[ -n "$s" ]] || return 1
  [[ "$s" =~ ^# ]] && return 1

  case "$s" in
    [\]\[\{\}\(\)\;]*) return 1 ;;
  esac

  [[ "$s" == *"://"* && ! "$s" =~ ^[A-Za-z_][A-Za-z0-9_.+-]*[[:space:]]*# ]] && return 1

  if [[ "$s" =~ ^([A-Za-z_][A-Za-z0-9_.+-]*)([[:space:]]*(#.*)?)?$ ]]; then
    out_pkg="${BASH_REMATCH[1]}"
    out_tail="${BASH_REMATCH[2]:-}"
  else
    return 1
  fi

  case "$out_pkg" in
    let|in|with|if|then|else|rec|true|false|null|pkgs|lib) return 1 ;;
  esac

  out_meta=""
  if [[ "$out_tail" =~ \#[[:space:]]?(.*)$ ]]; then
    out_meta="$(trim "${BASH_REMATCH[1]}")"
  fi

  printf -v "$__pkg" '%s' "$out_pkg"
  printf -v "$__enabled" '%s' "$out_enabled"
  printf -v "$__meta" '%s' "$out_meta"
  return 0
}


add_record() {
  local file="$1" line_no="$2" section="$3" pkg="$4" enabled="$5" orig="$6" meta="$7"
  local id="${#REC_PKG[@]}"
  REC_FILE[$id]="$file"
  REC_LINE[$id]="$line_no"
  REC_SECTION[$id]="$section"
  REC_PKG[$id]="$pkg"
  REC_ENABLED_ORIG[$id]="$enabled"
  REC_ENABLED[$id]="$enabled"
  REC_ORIG_TEXT[$id]="$orig"
  REC_META[$id]="$meta"
  LINE_TO_REC["$file|$line_no"]="$id"
}

rebuild_stats() {
  FILE_TOTAL=()
  FILE_ACTIVE=()
  FILE_DIRTY=()
  SECTION_TOTAL=()
  SECTION_ACTIVE=()
  SECTION_DIRTY=()

  local file
  for file in "${FILES[@]}"; do
    FILE_TOTAL["$file"]=0
    FILE_ACTIVE["$file"]=0
    FILE_DIRTY["$file"]=0
  done

  local id file section key
  for id in "${!REC_PKG[@]}"; do
    file="${REC_FILE[$id]}"
    section="${REC_SECTION[$id]}"
    key="$file|$section"
    ((FILE_TOTAL["$file"]++)) || true
    ((SECTION_TOTAL["$key"]++)) || true
    if [[ "${REC_ENABLED[$id]}" == "1" ]]; then
      ((FILE_ACTIVE["$file"]++)) || true
      ((SECTION_ACTIVE["$key"]++)) || true
    fi
    if [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]]; then
      FILE_DIRTY["$file"]=1
      SECTION_DIRTY["$key"]=1
    fi
  done
}

workspace_dirty() {
  local id
  for id in "${!REC_PKG[@]}"; do
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && return 0
  done
  return 1
}

file_dirty() {
  local file="$1" id
  for id in "${!REC_PKG[@]}"; do
    [[ "${REC_FILE[$id]}" == "$file" && "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && return 0
  done
  return 1
}

# -----------------------------------------------------------------------------
# Content generation / diff / save
# -----------------------------------------------------------------------------

generate_file_content() {
  local file="$1"
  local out="$2"
  local line_no=0 line rec_id desired

  : > "$out"
  while IFS= read -r line || [[ -n "$line" ]]; do
    ((line_no++)) || true
    rec_id="${LINE_TO_REC[$file|$line_no]:-}"
    if [[ -n "$rec_id" ]]; then
      desired="${REC_ENABLED[$rec_id]}"
      transform_package_line "$line" "$desired" >> "$out"
    else
      printf '%s\n' "$line" >> "$out"
    fi
  done < "$file"
}

transform_package_line() {
  local line="$1"
  local desired="$2"
  local indent rest

  if [[ "$desired" == "1" ]]; then
    if [[ "$line" =~ ^([[:space:]]*)#[[:space:]]?(.*)$ ]]; then
      printf '%s%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    else
      printf '%s\n' "$line"
    fi
  else
    if [[ "$line" =~ ^[[:space:]]*# ]]; then
      printf '%s\n' "$line"
    elif [[ "$line" =~ ^([[:space:]]*)(.*)$ ]]; then
      indent="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
      printf '%s# %s\n' "$indent" "$rest"
    else
      printf '# %s\n' "$line"
    fi
  fi
}

append_diff_for_file() {
  local file="$1"
  local diff_out="$2"
  local newfile="$TUINIX_TMPDIR/new.$(basename_safe "$file").$$"

  generate_file_content "$file" "$newfile"
  if cmp -s "$file" "$newfile"; then
    rm -f -- "$newfile"
    return
  fi

  if has_cmd git; then
    git diff --no-index -- "$file" "$newfile" >> "$diff_out" 2>/dev/null || true
  elif has_cmd diff; then
    diff -u -- "$file" "$newfile" >> "$diff_out" || true
  else
    printf 'Diff unavailable for %s\n' "$file" >> "$diff_out"
  fi
  printf '\n' >> "$diff_out"
  rm -f -- "$newfile"
}

make_diff_all() {
  local out="$1"
  : > "$out"
  local file
  for file in "${FILES[@]}"; do
    append_diff_for_file "$file" "$out"
  done
}

save_file() {
  local file="$1"
  local newfile="$TUINIX_TMPDIR/save.$(basename_safe "$file").$$"
  local backup_latest="${file}${TUINIX_BACKUP_SUFFIX}"
  local stamp backup_stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup_stamp="${file}${TUINIX_BACKUP_SUFFIX}.${stamp}"

  generate_file_content "$file" "$newfile"
  if cmp -s "$file" "$newfile"; then
    rm -f -- "$newfile"
    return
  fi

  cp -p -- "$file" "$backup_latest"
  cp -p -- "$file" "$backup_stamp"
  mv -- "$newfile" "$file"
}

save_all_dirty() {
  local file
  for file in "${FILES[@]}"; do
    if file_dirty "$file"; then
      save_file "$file"
    fi
  done
  parse_workspace
}

# -----------------------------------------------------------------------------
# Git support
# -----------------------------------------------------------------------------

git_available() {
  has_cmd git
}

git_is_repo() {
  git_available || return 1
  git -C "$TUINIX_GIT_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

git_has_commits() {
  git_is_repo || return 1
  git -C "$TUINIX_GIT_ROOT" rev-parse --verify HEAD >/dev/null 2>&1
}

git_add_managed_files() {
  git_is_repo || return 1
  local paths=()
  local file
  for file in "${FILES[@]}"; do
    paths+=("$(relpath_from_git_root "$file")")
  done
  git -C "$TUINIX_GIT_ROOT" add -- "${paths[@]}"
}

git_ensure_gitignore() {
  local gi="$TUINIX_GIT_ROOT/.gitignore"
  touch "$gi"
  grep -qxF '*.bak' "$gi" 2>/dev/null || printf '%s\n' '*.bak' >> "$gi"
  grep -qxF '*.bak.*' "$gi" 2>/dev/null || printf '%s\n' '*.bak.*' >> "$gi"
  grep -qxF '.tuinix/' "$gi" 2>/dev/null || printf '%s\n' '.tuinix/' >> "$gi"
  git -C "$TUINIX_GIT_ROOT" add -- .gitignore >/dev/null 2>&1 || true
}

git_init_repo() {
  git_available || { yad_error "Git não encontrado no PATH."; return 1; }

  mkdir -p -- "$TUINIX_GIT_ROOT"
  if ! git_is_repo; then
    git -C "$TUINIX_GIT_ROOT" init || { yad_error "Falha ao executar git init em:\n$TUINIX_GIT_ROOT"; return 1; }
  fi

  git_ensure_gitignore
  git_add_managed_files || true

  if ! git_has_commits; then
    if git -C "$TUINIX_GIT_ROOT" diff --cached --quiet --exit-code; then
      return 0
    fi
    if ! git -C "$TUINIX_GIT_ROOT" commit -m "tuinix: baseline" >/tmp/tuinix-git-commit.$$.log 2>&1; then
      yad_text_file "Git inicializado, mas commit baseline falhou" "/tmp/tuinix-git-commit.$$.log"
      rm -f "/tmp/tuinix-git-commit.$$.log"
      return 0
    fi
    rm -f "/tmp/tuinix-git-commit.$$.log"
  fi
}

git_commit_current() {
  git_available || { yad_error "Git não encontrado no PATH."; return 1; }
  git_is_repo || git_init_repo || return 1
  git_add_managed_files || true

  if git -C "$TUINIX_GIT_ROOT" diff --cached --quiet --exit-code; then
    yad_info "Git" "Nenhuma alteração staged nos arquivos gerenciados."
    return 0
  fi

  local msg="tuinix: update packages $(date '+%Y-%m-%d %H:%M:%S')"
  local log="$TUINIX_TMPDIR/git-commit.log"
  if git -C "$TUINIX_GIT_ROOT" commit -m "$msg" >"$log" 2>&1; then
    yad_text_file "Git commit criado" "$log"
  else
    yad_text_file "Git commit falhou" "$log"
  fi
}

git_status_file() {
  local out="$1"
  : > "$out"
  if ! git_available; then
    printf 'git não encontrado.\n' > "$out"
    return
  fi
  if ! git_is_repo; then
    printf 'Esta pasta ainda não é um repositório Git.\n\nRoot configurado:\n%s\n' "$TUINIX_GIT_ROOT" > "$out"
    return
  fi
  {
    printf 'Root: %s\n\n' "$TUINIX_GIT_ROOT"
    printf 'Status:\n'
    git -C "$TUINIX_GIT_ROOT" status --short || true
    printf '\nÚltimos commits:\n'
    git -C "$TUINIX_GIT_ROOT" --no-pager log --oneline -n 10 || true
  } > "$out"
}

maybe_offer_git_init() {
  git_available || return 0

  if [[ "$TUINIX_GIT_AUTO_INIT" == "1" ]]; then
    git_is_repo || git_init_repo || true
    return 0
  fi

  if ! git_is_repo; then
    if yad_question "Git" "A pasta atual ainda não é um repositório Git.\n\nDeseja iniciar um repositório local para controlar as alterações dos .nix?\n\nPasta:\n$TUINIX_GIT_ROOT"; then
      git_init_repo || true
    fi
  fi
}

git_menu() {
  local choice
  choice="$(yad --list \
    --title="TUINIX · Git" \
    --width=650 --height=360 --center \
    --column="Ação" --column="Descrição" \
    --print-column=1 \
    "init" "Inicializar repositório local e criar baseline" \
    "commit" "Commitar alterações atuais dos arquivos .nix" \
    "status" "Mostrar status e últimos commits" \
    "cancel" "Voltar" \
  )" || return 0

  case "$choice" in
    init) git_init_repo ;;
    commit) git_commit_current ;;
    status)
      local st="$TUINIX_TMPDIR/git-status.txt"
      git_status_file "$st"
      yad_text_file "Git status" "$st"
      ;;
  esac
}

# -----------------------------------------------------------------------------
# URL helpers
# -----------------------------------------------------------------------------

urlencode() {
  local s="$1"
  local out=""
  local i c hex old_lc="${LC_ALL:-}"
  LC_ALL=C
  for ((i=0; i<${#s}; i++)); do
    c="${s:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-]) out+="$c" ;;
      *) printf -v hex '%%%02X' "'$c"; out+="$hex" ;;
    esac
  done
  if [[ -n "$old_lc" ]]; then LC_ALL="$old_lc"; else unset LC_ALL; fi
  printf '%s' "$out"
}

nixos_search_url() {
  local pkg="$1"
  local query
  query="$(urlencode "$pkg")"
  printf 'https://search.nixos.org/packages?channel=%s&query=%s\n' "$TUINIX_NIXOS_CHANNEL" "$query"
}

open_url() {
  local url="$1"
  local opener="" cmd
  for cmd in xdg-open gio open kde-open wslview; do
    if has_cmd "$cmd"; then opener="$cmd"; break; fi
  done

  if [[ -n "$opener" ]]; then
    case "$opener" in
      gio) gio open "$url" >/dev/null 2>&1 & ;;
      *) "$opener" "$url" >/dev/null 2>&1 & ;;
    esac
  else
    local tmp="$TUINIX_TMPDIR/url.txt"
    printf '%s\n' "$url" > "$tmp"
    yad_text_file "NixOS Search URL" "$tmp"
  fi
}

choose_package_to_open() {
  local args=()
  local id
  for id in "${!REC_PKG[@]}"; do
    args+=("$id" "$(basename_safe "${REC_FILE[$id]}")" "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "${REC_META[$id]}")
  done

  local chosen
  chosen="$(yad --list \
    --title="TUINIX · Abrir pacote" \
    --text="Escolha um pacote para abrir no search.nixos.org" \
    --width=1000 --height=650 --center \
    --search-column=4 \
    --column="ID:HD" --column="Arquivo" --column="Seção" --column="Pacote" --column="Comentário" \
    --print-column=1 \
    "${args[@]}" \
  )" || return 0

  [[ -n "$chosen" ]] || return 0
  if [[ -n "${REC_PKG[$chosen]+x}" ]]; then
    open_url "$(nixos_search_url "${REC_PKG[$chosen]}")"
  fi
}

# -----------------------------------------------------------------------------
# YAD UI wrappers
# -----------------------------------------------------------------------------

yad_info() {
  local title="$1" text="$2"
  yad --info --center --title="$title" --text="$text" --width=520 --button="OK:0" >/dev/null 2>&1 || true
}

yad_error() {
  local text="$1"
  yad --error --center --title="TUINIX" --text="$text" --width=650 --button="OK:0" >/dev/null 2>&1 || true
}

yad_question() {
  local title="$1" text="$2"
  yad --question --center --title="$title" --text="$text" --width=650 --button="Não:1" --button="Sim:0" >/dev/null 2>&1
}

yad_text_file() {
  local title="$1" file="$2"
  yad --text-info \
    --title="$title" \
    --width=1000 --height=700 --center \
    --filename="$file" \
    --button="Fechar:0" >/dev/null 2>&1 || true
}

workspace_summary() {
  rebuild_stats
  local files_count="${#FILES[@]}"
  local pkg_count="${#REC_PKG[@]}"
  local active=0 dirty=0 id
  for id in "${!REC_PKG[@]}"; do
    [[ "${REC_ENABLED[$id]}" == "1" ]] && ((active++)) || true
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && ((dirty++)) || true
  done
  printf 'Arquivos: %s · Pacotes: %s · Ativos: %s · Alterados: %s' "$files_count" "$pkg_count" "$active" "$dirty"
}

make_main_rows() {
  local -n __rows="$1"
  __rows=()
  local id checked dirty file base section pkg meta usage
  for id in "${!REC_PKG[@]}"; do
    checked="FALSE"
    [[ "${REC_ENABLED[$id]}" == "1" ]] && checked="TRUE"
    dirty=""
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && dirty="*"
    file="${REC_FILE[$id]}"
    base="$(basename_safe "$file")"
    section="${REC_SECTION[$id]}"
    pkg="${REC_PKG[$id]}"
    meta="${REC_META[$id]}"
    usage="$meta"
    [[ -z "$usage" ]] && usage="linha ${REC_LINE[$id]}"
    __rows+=("$checked" "$id" "$dirty" "$base" "$section" "$pkg" "$usage")
  done
}

apply_yad_rows_output() {
  local output_file="$1"
  [[ -f "$output_file" ]] || return 0
  local line checked id rest
  local changed=0

  # With --print-all and tab separator, YAD emits all visible rows. The first two
  # fields are checkbox state and hidden record id.
  while IFS=$'\t' read -r checked id rest || [[ -n "${checked:-}" ]]; do
    [[ -n "${id:-}" ]] || continue
    [[ "$id" =~ ^[0-9]+$ ]] || continue
    [[ -n "${REC_PKG[$id]+x}" ]] || continue
    case "$checked" in
      TRUE|True|true|1|yes|YES|on|ON) REC_ENABLED[$id]=1 ;;
      *) REC_ENABLED[$id]=0 ;;
    esac
    changed=1
  done < "$output_file"

  [[ "$changed" == "1" ]] && rebuild_stats
}

show_diff_all() {
  local diff_file="$TUINIX_TMPDIR/diff-all.txt"
  make_diff_all "$diff_file"
  if [[ ! -s "$diff_file" ]]; then
    yad_info "Diff" "Sem diferenças."
  else
    yad_text_file "TUINIX · Diff" "$diff_file"
  fi
}

show_restore_dialog() {
  local rows=()
  local f b
  for f in "${FILES[@]}"; do
    [[ -f "${f}${TUINIX_BACKUP_SUFFIX}" ]] && rows+=("${f}${TUINIX_BACKUP_SUFFIX}" "$(basename_safe "$f")" "latest")
    while IFS= read -r -d '' b; do
      rows+=("$b" "$(basename_safe "$f")" "timestamp")
    done < <(find "$(dirname -- "$f")" -maxdepth 1 -type f -name "$(basename_safe "$f")${TUINIX_BACKUP_SUFFIX}.*" -print0 | sort -zr)
  done

  if [[ ${#rows[@]} -eq 0 ]]; then
    yad_info "Restore" "Nenhum backup encontrado."
    return 0
  fi

  local chosen
  chosen="$(yad --list \
    --title="TUINIX · Restore backup" \
    --width=900 --height=500 --center \
    --column="Backup:HD" --column="Arquivo" --column="Tipo" \
    --print-column=1 \
    "${rows[@]}" \
  )" || return 0

  [[ -n "$chosen" ]] || return 0
  local target=""
  local ff
  for ff in "${FILES[@]}"; do
    case "$chosen" in
      "$ff"*) target="$ff"; break ;;
    esac
  done
  [[ -n "$target" ]] || { yad_error "Não consegui determinar o arquivo alvo."; return 1; }

  if yad_question "Restore" "Restaurar este backup?\n\nBackup:\n$chosen\n\nDestino:\n$target"; then
    cp -p -- "$target" "${target}.pre-restore.$(date +%Y%m%d-%H%M%S)"
    cp -p -- "$chosen" "$target"
    parse_workspace
    yad_info "Restore" "Backup restaurado."
  fi
}

save_flow() {
  if ! workspace_dirty; then
    yad_info "Salvar" "Nada para salvar."
    return 0
  fi

  show_diff_all
  if yad_question "Salvar" "Salvar alterações nos arquivos .nix?\n\nBackups .bak serão criados antes da gravação."; then
    save_all_dirty
    TUINIX_LAST_STATUS="Salvo em $(date '+%H:%M:%S')"
    if git_is_repo; then
      if [[ "$TUINIX_GIT_AUTO_COMMIT" == "1" ]] || yad_question "Git" "Criar commit Git com as alterações salvas?"; then
        git_commit_current || true
      fi
    fi
  fi
}

yad_main_loop() {
  local out rc rows=()

  while true; do
    rebuild_stats
    make_main_rows rows
    out="$TUINIX_TMPDIR/yad-main-output.tsv"
    : > "$out"

    local text
    text="<b>$TUINIX_NAME</b> · $TUINIX_VERSION\n$(workspace_summary)"
    if [[ -n "$TUINIX_LAST_STATUS" ]]; then
      text="$text\n$TUINIX_LAST_STATUS"
    fi

    set +e
    yad --list --checklist --editable --print-all \
      --separator=$'\t' \
      --title="TUINIX · Nix package toggler" \
      --text="$text" \
      --width="$TUINIX_WIDTH" --height="$TUINIX_HEIGHT" --center \
      --grid-lines=both \
      --search-column=6 \
      --column="Ativo:CHK" \
      --column="ID:HD" \
      --column="Δ" \
      --column="Arquivo" \
      --column="Seção" \
      --column="Pacote" \
      --column="Uso / comentário" \
      --button="💾 Salvar:0" \
      --button="📊 Diff:2" \
      --button="🌐 NixOS:3" \
      --button="↺ Recarregar:4" \
      --button="🧬 Git:5" \
      --button="🧯 Restore:6" \
      --button="Sair:1" \
      "${rows[@]}" > "$out"
    rc=$?
    set -e

    apply_yad_rows_output "$out"

    case "$rc" in
      0)
        save_flow
        ;;
      1|252)
        if workspace_dirty; then
          if yad_question "Sair" "Existem alterações não salvas.\n\nSair mesmo assim?"; then
            break
          fi
        else
          break
        fi
        ;;
      2)
        show_diff_all
        ;;
      3)
        choose_package_to_open
        ;;
      4)
        if workspace_dirty; then
          if yad_question "Recarregar" "Descartar alterações em memória e reler os arquivos?"; then
            parse_workspace
            TUINIX_LAST_STATUS="Recarregado em $(date '+%H:%M:%S')"
          fi
        else
          parse_workspace
          TUINIX_LAST_STATUS="Recarregado em $(date '+%H:%M:%S')"
        fi
        ;;
      5)
        git_menu
        ;;
      6)
        show_restore_dialog
        ;;
      *)
        # YAD may return other button/window codes depending on WM/theme.
        if workspace_dirty; then
          yad_info "TUINIX" "Ação cancelada. Alterações continuam em memória."
        else
          break
        fi
        ;;
    esac
  done
}

main "$@"
