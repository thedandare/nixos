#!/usr/bin/env bash
#
# TUINIX - Terminal UI Nix package toggler
# Monolithic Bash edition - dialog/mouse backend
#
# Reads one or more .nix files, finds packages inside:
#
#   environment.systemPackages = with pkgs; [
#     foo
#     # bar
#   ];
#
# and lets you enable/disable them through dialog menus with mouse support.
#
# Requirements:
#   - bash 4+
#   - dialog
# Optional:
#   - diff, git, bat/less/pager
#
# Usage:
#   ./tuinix.sh file1.nix file2.nix
#   ./tuinix.sh
#
# If no file is passed, TUINIX reads all *.nix files in the current directory.
#
# Design notes:
#   - dialog provides mouse-enabled menus/checklists. TUINIX simulates file tabs through menu layers.
#   - All changes are kept in memory until Save.
#   - Save creates .bak and timestamped backups.
#   - Parser is intentionally conservative: it edits simple package lines only.
#

set -Eeuo pipefail

# -----------------------------------------------------------------------------
# Global configuration
# -----------------------------------------------------------------------------

TUINIX_NAME="TUINIX"
TUINIX_VERSION="2.1.0-dialog-monolith"
TUINIX_TMPDIR=""
TUINIX_WIDTH="${TUINIX_WIDTH:-100}"
TUINIX_HEIGHT="${TUINIX_HEIGHT:-18}"
TUINIX_DEBUG="${TUINIX_DEBUG:-0}"
TUINIX_NO_COLOR="${NO_COLOR:-}"
TUINIX_BACKUP_SUFFIX=".bak"
TUINIX_LAST_STATUS=""

# Workspace files
# shellcheck disable=SC2034
FILES=()

# Records. A record is one editable package occurrence.
# ID/index is the array index.
REC_FILE=()
REC_LINE=()
REC_SECTION=()
REC_PKG=()
REC_ENABLED_ORIG=()
REC_ENABLED=()
REC_ORIG_TEXT=()
REC_META=()

# Derived indexes and state maps.
declare -A FILE_TOTAL=()
declare -A FILE_ACTIVE=()
declare -A FILE_DIRTY=()
declare -A SECTION_TOTAL=()
declare -A SECTION_ACTIVE=()
declare -A SECTION_DIRTY=()
declare -A LINE_TO_REC=()
declare -A FILE_INDEX=()

CURRENT_FILE_INDEX=0
CURRENT_FILE=""
CURRENT_SECTION=""

# -----------------------------------------------------------------------------
# Basic helpers
# -----------------------------------------------------------------------------

main() {
  init_runtime
  parse_args_and_files "$@"
  require_dependencies
  parse_workspace
  ui_main_loop
}

init_runtime() {
  TUINIX_TMPDIR="$(mktemp -d -t tuinix.XXXXXX)"
  trap cleanup EXIT
}

cleanup() {
  local code=$?
  if [[ -n "${TUINIX_TMPDIR:-}" && -d "${TUINIX_TMPDIR:-}" ]]; then
    rm -rf -- "$TUINIX_TMPDIR"
  fi
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
  if [[ "$TUINIX_DEBUG" == "1" ]]; then
    printf 'DEBUG: %s\n' "$*" >&2
  fi
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

strip_ansi() {
  sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g'
}

repeat_char() {
  local ch="$1"
  local n="$2"
  local out=""
  local i
  for ((i=0; i<n; i++)); do out+="$ch"; done
  printf '%s' "$out"
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
    printf '%s\n' "$p"
  fi
}

require_dependencies() {
  if ! has_cmd dialog; then
    cat >&2 <<'MSG'
TUINIX dialog edition requires dialog, but dialog was not found in PATH.

On Nix/NixOS you can try:

  nix shell nixpkgs#dialog

or add `dialog` to your environment.systemPackages.
MSG
    exit 127
  fi

  if ! has_cmd awk; then die "awk is required"; fi
  if ! has_cmd sed; then die "sed is required"; fi
  if ! has_cmd diff; then warn "diff not found; diff view will be unavailable"; fi
}

parse_args_and_files() {
  FILES=()

  if [[ $# -gt 0 ]]; then
    local arg
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
    while IFS= read -r -d '' f; do
      FILES+=("$(abspath "$f")")
    done < <(find . -maxdepth 1 -type f -name '*.nix' -print0 | sort -z)
  fi

  if [[ ${#FILES[@]} -eq 0 ]]; then
    die "no .nix files found"
  fi

  local i
  for i in "${!FILES[@]}"; do
    FILE_INDEX["${FILES[$i]}"]="$i"
  done
}

# -----------------------------------------------------------------------------
# Dialog wrappers
# -----------------------------------------------------------------------------

# TUINIX v2.1 uses dialog as UI backend. Unlike gum, dialog has native mouse
# support for menus/checklists when --mouse is enabled and the terminal supports
# mouse reporting. Most functions below intentionally keep the old wrapper names
# so the rest of the monolith can be reused almost unchanged.

DIALOG_COMMON=(--stdout --clear --mouse --backtitle "$TUINIX_NAME $TUINIX_VERSION")

style_title() {
  local text="$1"
  printf '
== %s ==

' "$text"
}

style_box() {
  local text="$1"
  printf '%s
' "$text"
}

style_error() {
  printf 'ERRO: %s
' "$*"
}

style_ok() {
  printf 'OK: %s' "$*"
}

style_warn() {
  printf 'AVISO: %s' "$*"
}

pause() {
  dialog "${DIALOG_COMMON[@]}" --msgbox "Pressione Enter para continuar." 7 50 >/dev/null || true
}

confirm() {
  local msg="$1"
  dialog "${DIALOG_COMMON[@]}" --yesno "$msg" 8 70
}

# choose_one PROMPT ITEM...
# Returns the selected ITEM text, not the numeric dialog tag.
choose_one() {
  local prompt="$1"
  shift

  local tmp_items="$TUINIX_TMPDIR/dialog-items.$$"
  : > "$tmp_items"

  local -a args=()
  local i=0 item tag
  for item in "$@"; do
    tag="$(printf '%03d' "$i")"
    printf '%s	%s
' "$tag" "$item" >> "$tmp_items"
    args+=("$tag" "$item")
    ((i++)) || true
  done

  [[ ${#args[@]} -gt 0 ]] || return 1

  local tag_selected
  tag_selected="$(dialog "${DIALOG_COMMON[@]}"     --cancel-label "Voltar"     --menu "$prompt" "$TUINIX_HEIGHT" "$TUINIX_WIDTH" $(( TUINIX_HEIGHT - 8 ))     "${args[@]}")" || return 1

  awk -F '	' -v t="$tag_selected" '$1 == t { print substr($0, length($1) + 2); exit }' "$tmp_items"
}

# Generic checklist wrapper. Existing callers mostly use the specialized section
# editor below, but this is useful for extensions.
choose_multi() {
  local prompt="$1"
  shift

  local tmp_items="$TUINIX_TMPDIR/dialog-check-items.$$"
  : > "$tmp_items"

  local -a args=()
  local i=0 item tag
  for item in "$@"; do
    tag="$(printf '%03d' "$i")"
    printf '%s	%s
' "$tag" "$item" >> "$tmp_items"
    args+=("$tag" "$item" "off")
    ((i++)) || true
  done

  [[ ${#args[@]} -gt 0 ]] || return 1

  local selected_tags
  selected_tags="$(dialog "${DIALOG_COMMON[@]}"     --separate-output     --checklist "$prompt" "$TUINIX_HEIGHT" "$TUINIX_WIDTH" $(( TUINIX_HEIGHT - 8 ))     "${args[@]}")" || return 1

  local t
  while IFS= read -r t; do
    [[ -n "$t" ]] || continue
    awk -F '	' -v tag="$t" '$1 == tag { print substr($0, length($1) + 2); exit }' "$tmp_items"
  done <<< "$selected_tags"
}

input_text() {
  local prompt="$1"
  local initial="${2:-}"
  dialog "${DIALOG_COMMON[@]}" --inputbox "$prompt" 8 70 "$initial"
}

filter_one() {
  local prompt="$1"
  local tmp_all="$TUINIX_TMPDIR/filter-all.$$"
  local tmp_match="$TUINIX_TMPDIR/filter-match.$$"
  cat > "$tmp_all"

  local term
  term="$(input_text "$prompt")" || return 1

  if [[ -n "$term" ]]; then
    grep -i -- "$term" "$tmp_all" > "$tmp_match" || true
  else
    cp -- "$tmp_all" "$tmp_match"
  fi

  if [[ ! -s "$tmp_match" ]]; then
    dialog "${DIALOG_COMMON[@]}" --msgbox "Nenhum resultado para: $term" 8 60 >/dev/null || true
    return 1
  fi

  mapfile -t _filter_items < "$tmp_match"
  choose_one "Resultados" "${_filter_items[@]}"
}

pager_text() {
  local title="$1"
  local file="$2"
  dialog "${DIALOG_COMMON[@]}" --title "$title" --textbox "$file" 0 0 || true
}

clear_screen() {
  clear 2>/dev/null || printf 'c'
}
# -----------------------------------------------------------------------------
# Parser helpers
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

  FILE_TOTAL=()
  FILE_ACTIVE=()
  FILE_DIRTY=()
  SECTION_TOTAL=()
  SECTION_ACTIVE=()
  SECTION_DIRTY=()
  LINE_TO_REC=()
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

  debug "parsing $file"

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
  local line="$1"
  local s
  s="$(trim "$line")"

  # Most systemPackages lists end with `];` or `]`.
  # This deliberately ignores `]` inside comments unless the line begins with it.
  [[ "$s" =~ ^\] ]] && return 0
  return 1
}

# Return a cleaned section name on stdout, or empty if the comment line is not
# considered a section header.
extract_section_name() {
  local line="$1"
  local s content cleaned words

  s="$line"
  [[ "$s" =~ ^[[:space:]]*# ]] || return 1

  # Remove leading whitespace and first #.
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s#\#}"
  content="$(trim "$s")"
  [[ -n "$content" ]] || return 1

  # Reject obvious non-heading comments.
  case "$content" in
    http*|https*|c.f:*|cf:*|c.f*|Programs\ provided:*|Programas\ fornecidos:* ) return 1 ;;
  esac
  [[ "$content" == *"://"* ]] && return 1
  [[ "$content" =~ ^(It|For|The|This|A|An|and|or|to|from)[[:space:]] ]] && return 1
  [[ "$content" =~ ^[[:space:]]*[🔧🔩] ]] && return 1

  # If it looks like a disabled lowercase package, do not turn it into section.
  if [[ "$content" =~ ^[a-z0-9_][A-Za-z0-9_.+-]*([[:space:]]*(#.*)?)?$ ]]; then
    return 1
  fi

  cleaned="$content"
  # Replace common box-drawing/decorative separators with spaces. Keep emojis and
  # unicode letters because the user's files use them as visual section labels.
  # Bash substitutions handle unicode box chars more reliably than some sed builds.
  local deco
  for deco in "▐" "▌" "▀" "▄" "█" "─" "━" "═" "║" "╔" "╗" "╚" "╝" "╠" "╣" "╦" "╩" "╬"; do
    cleaned="${cleaned//${deco}/ }"
  done
  cleaned="$(printf '%s' "$cleaned" | sed -E \
    -e 's/[#=+*_|<>~`.,;:(){}\[\]\/\\-]+/ /g' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+$//')"

  [[ -n "$cleaned" ]] || return 1

  # Reject long prose comments.
  words="$(awk '{print NF}' <<< "$cleaned")"
  if [[ "$words" -gt 7 ]]; then
    return 1
  fi

  # Reject sentences even if short.
  [[ "$cleaned" == *"."* ]] && return 1

  # Accept comments that were visibly decorative or title-like.
  if [[ "$content" == *"▐"* || "$content" == *"▀"* || "$content" == *"▄"* || "$content" == *"═"* || "$content" == *"─"* ]]; then
    printf '%s\n' "$cleaned"
    return 0
  fi

  # Accept title-case / emoji-leading short headings.
  if [[ "$cleaned" =~ ^[[:upper:]] ]]; then
    printf '%s\n' "$cleaned"
    return 0
  fi

  if [[ "$cleaned" =~ ^[^A-Za-z0-9] ]]; then
    printf '%s\n' "$cleaned"
    return 0
  fi

  return 1
}

# parsed_package_line LINE OUT_PKG OUT_ENABLED OUT_META
# Writes values into named variables passed by name.
parsed_package_line() {
  local line="$1"
  local __pkg_var="$2"
  local __enabled_var="$3"
  local __meta_var="$4"
  local body parsed_enabled parsed_pkg rest parsed_meta

  body="$line"
  body="${body#"${body%%[![:space:]]*}"}"
  [[ -n "$body" ]] || return 1

  parsed_enabled=1
  if [[ "$body" == \#* ]]; then
    # Could be a disabled package or a plain comment/header. Section headers have
    # already been handled before this function is called.
    parsed_enabled=0
    body="${body#\#}"
    body="${body#"${body%%[![:space:]]*}"}"
  fi

  [[ -n "$body" ]] || return 1

  # Reject Nix syntax and blocks we do not edit directly.
  case "$body" in
    \{*|\}*|\[*|\]*|\(*|\)*|let\ *|in\ *|with\ *|if\ *|then\ *|else\ *|inherit\ * ) return 1 ;;
  esac

  # Token must be a simple package-ish identifier. This covers names like:
  #   cpu-x
  #   pciutils
  #   python3Packages.numpy
  #   kdePackages.kate
  #   libsForQt5.qtstyleplugin-kvantum
  if [[ ! "$body" =~ ^([A-Za-z0-9_][A-Za-z0-9_.+-]*)(.*)$ ]]; then
    return 1
  fi

  parsed_pkg="${BASH_REMATCH[1]}"
  rest="${BASH_REMATCH[2]}"
  rest="$(trim "$rest")"

  # Avoid accidental parsing of prose comments as packages.
  case "$parsed_pkg" in
    It|For|The|This|That|Those|These|A|An|Programs|Programas|Package|Packages|c|cf|TODO|FIXME|NOTE ) return 1 ;;
  esac

  # If a commented line begins with uppercase and has no package-ish punctuation,
  # it is more likely a heading than a disabled package.
  if [[ "$parsed_enabled" == "0" && "$parsed_pkg" =~ ^[[:upper:]][A-Za-z0-9_]*$ && -z "$rest" ]]; then
    return 1
  fi

  # Remaining text is allowed when it is a comment or a comma/semicolon/comment.
  # Reject arbitrary words after the first token.
  if [[ -n "$rest" ]]; then
    if [[ ! "$rest" =~ ^([,;][[:space:]]*)?(#.*)?$ ]]; then
      return 1
    fi
  fi

  parsed_meta=""
  if [[ "$body" == *"#"* ]]; then
    parsed_meta="${body#*#}"
    parsed_meta="$(trim "$parsed_meta")"
  fi

  printf -v "$__pkg_var" '%s' "$parsed_pkg"
  printf -v "$__enabled_var" '%s' "$parsed_enabled"
  printf -v "$__meta_var" '%s' "$parsed_meta"
  return 0
}

add_record() {
  local file="$1"
  local line_no="$2"
  local section="$3"
  local pkg="$4"
  local enabled="$5"
  local text="$6"
  local meta="$7"
  local id="${#REC_FILE[@]}"

  REC_FILE[$id]="$file"
  REC_LINE[$id]="$line_no"
  REC_SECTION[$id]="$section"
  REC_PKG[$id]="$pkg"
  REC_ENABLED_ORIG[$id]="$enabled"
  REC_ENABLED[$id]="$enabled"
  REC_ORIG_TEXT[$id]="$text"
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

  local f id key enabled orig
  for f in "${FILES[@]}"; do
    FILE_TOTAL["$f"]=0
    FILE_ACTIVE["$f"]=0
    FILE_DIRTY["$f"]=0
  done

  for id in "${!REC_FILE[@]}"; do
    f="${REC_FILE[$id]}"
    key="$f|${REC_SECTION[$id]}"
    enabled="${REC_ENABLED[$id]}"
    orig="${REC_ENABLED_ORIG[$id]}"

    FILE_TOTAL["$f"]=$(( ${FILE_TOTAL[$f]:-0} + 1 ))
    SECTION_TOTAL["$key"]=$(( ${SECTION_TOTAL[$key]:-0} + 1 ))

    if [[ "$enabled" == "1" ]]; then
      FILE_ACTIVE["$f"]=$(( ${FILE_ACTIVE[$f]:-0} + 1 ))
      SECTION_ACTIVE["$key"]=$(( ${SECTION_ACTIVE[$key]:-0} + 1 ))
    fi

    if [[ "$enabled" != "$orig" ]]; then
      FILE_DIRTY["$f"]=1
      SECTION_DIRTY["$key"]=1
    fi
  done
}

workspace_dirty() {
  local id
  for id in "${!REC_FILE[@]}"; do
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && return 0
  done
  return 1
}

file_dirty() {
  local file="$1"
  [[ "${FILE_DIRTY[$file]:-0}" == "1" ]]
}

# -----------------------------------------------------------------------------
# Render helpers
# -----------------------------------------------------------------------------

render_header() {
  local subtitle="${1:-}"
  local dirty=""
  if workspace_dirty; then dirty="  *unsaved changes*"; fi

  clear_screen
  style_title "$TUINIX_NAME $TUINIX_VERSION$dirty"
  if [[ -n "$subtitle" ]]; then
    printf '%s\n\n' "$subtitle"
  fi
  if [[ -n "$TUINIX_LAST_STATUS" ]]; then
    printf '%s\n\n' "$TUINIX_LAST_STATUS"
    TUINIX_LAST_STATUS=""
  fi
}

render_tabs() {
  local current="$1"
  local i f name tab line=""
  for i in "${!FILES[@]}"; do
    f="${FILES[$i]}"
    name="$(basename_safe "$f")"
    if [[ "$f" == "$current" ]]; then
      tab="[$name]"
    else
      tab=" $name "
    fi
    if file_dirty "$f"; then
      tab+="*"
    fi
    line+="$tab  "
  done
  printf '%s\n\n' "$line"
}

file_label() {
  local idx="$1"
  local f="${FILES[$idx]}"
  local name total active dirty_marker
  name="$(basename_safe "$f")"
  total="${FILE_TOTAL[$f]:-0}"
  active="${FILE_ACTIVE[$f]:-0}"
  dirty_marker=""
  if file_dirty "$f"; then dirty_marker=" *"; fi
  printf '%02d │ %-36s %4s/%-4s active%s' "$idx" "$name" "$active" "$total" "$dirty_marker"
}

section_label() {
  local file="$1"
  local section="$2"
  local key="$file|$section"
  local total="${SECTION_TOTAL[$key]:-0}"
  local active="${SECTION_ACTIVE[$key]:-0}"
  local dirty_marker=""
  [[ "${SECTION_DIRTY[$key]:-0}" == "1" ]] && dirty_marker=" *"
  printf '%-42s %4s/%-4s active%s' "$section" "$active" "$total" "$dirty_marker"
}

record_label() {
  local id="$1"
  local mark="☐"
  [[ "${REC_ENABLED[$id]}" == "1" ]] && mark="☑"
  local dirty=""
  [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && dirty=" *"
  local meta="${REC_META[$id]}"
  if [[ -n "$meta" ]]; then
    printf '%s %-32s # %s%s' "$mark" "${REC_PKG[$id]}" "$meta" "$dirty"
  else
    printf '%s %s%s' "$mark" "${REC_PKG[$id]}" "$dirty"
  fi
}

# -----------------------------------------------------------------------------
# UI main loop
# -----------------------------------------------------------------------------

ui_main_loop() {
  while true; do
    rebuild_stats
    render_header "Selecione uma aba/arquivo ou uma ação."

    local choices=()
    local i
    for i in "${!FILES[@]}"; do
      choices+=("$(file_label "$i")")
    done

    choices+=("────────────────────────────────────────")
    choices+=("🔎 Busca global")
    choices+=("📊 Diff")
    choices+=("💾 Salvar tudo")
    choices+=("🧯 Restaurar backup")
    choices+=("📈 Estatísticas")
    choices+=("🔄 Recarregar do disco")
    choices+=("❌ Sair")

    local choice
    choice="$(choose_one "Arquivos / ações" "${choices[@]}")" || exit_or_continue

    case "$choice" in
      "────────────────────────────────────────") ;;
      "🔎 Busca global") ui_global_search ;;
      "📊 Diff") ui_diff_all ;;
      "💾 Salvar tudo") ui_save_all ;;
      "🧯 Restaurar backup") ui_restore_backup ;;
      "📈 Estatísticas") ui_stats ;;
      "🔄 Recarregar do disco") ui_reload ;;
      "❌ Sair") ui_exit ;;
      "") ;;
      *)
        if [[ "$choice" =~ ^([0-9]+)[[:space:]]*│ ]]; then
          CURRENT_FILE_INDEX="${BASH_REMATCH[1]}"
          CURRENT_FILE="${FILES[$CURRENT_FILE_INDEX]}"
          ui_sections "$CURRENT_FILE"
        fi
        ;;
    esac
  done
}

exit_or_continue() {
  return 0
}

ui_exit() {
  if workspace_dirty; then
    if confirm "Há alterações não salvas. Sair mesmo assim?"; then
      exit 0
    fi
  else
    exit 0
  fi
}

ui_reload() {
  if workspace_dirty; then
    if ! confirm "Descartar alterações em memória e recarregar do disco?"; then
      return
    fi
  fi
  parse_workspace
  TUINIX_LAST_STATUS="$(style_ok "Workspace recarregado.")"
}

# -----------------------------------------------------------------------------
# UI sections
# -----------------------------------------------------------------------------

ui_sections() {
  local file="$1"

  while true; do
    rebuild_stats
    render_header "Arquivo: $(basename_safe "$file")"
    render_tabs "$file"

    local sections=()
    collect_sections_for_file "$file" sections

    if [[ ${#sections[@]} -eq 0 ]]; then
      style_warn "Nenhum pacote editável encontrado neste arquivo."
      pause
      return
    fi

    local choices=()
    local s
    for s in "${sections[@]}"; do
      choices+=("$(section_label "$file" "$s")")
    done
    choices+=("────────────────────────────────────────")
    choices+=("🔎 Buscar pacote neste arquivo")
    choices+=("📊 Diff deste arquivo")
    choices+=("💾 Salvar este arquivo")
    choices+=("← Voltar")

    local choice
    choice="$(choose_one "Seções" "${choices[@]}")" || return

    case "$choice" in
      "────────────────────────────────────────") ;;
      "🔎 Buscar pacote neste arquivo") ui_file_search "$file" ;;
      "📊 Diff deste arquivo") ui_diff_file "$file" ;;
      "💾 Salvar este arquivo") ui_save_file "$file" ;;
      "← Voltar") return ;;
      "") ;;
      *)
        local matched=""
        for s in "${sections[@]}"; do
          if [[ "${choice:0:${#s}}" == "$s" ]]; then
            matched="$s"
            break
          fi
        done
        [[ -n "$matched" ]] && ui_packages "$file" "$matched"
        ;;
    esac
  done
}

collect_sections_for_file() {
  local file="$1"
  local __out_var="$2"
  local -A seen=()
  local out=()
  local id sec

  for id in "${!REC_FILE[@]}"; do
    [[ "${REC_FILE[$id]}" == "$file" ]] || continue
    sec="${REC_SECTION[$id]}"
    if [[ -z "${seen[$sec]+x}" ]]; then
      seen["$sec"]=1
      out+=("$sec")
    fi
  done

  eval "$__out_var"'=()'
  local item
  for item in "${out[@]}"; do
    eval "$__out_var"'+=("$item")'
  done
}

# -----------------------------------------------------------------------------
# UI packages
# -----------------------------------------------------------------------------

ui_packages() {
  local file="$1"
  local section="$2"

  while true; do
    rebuild_stats
    render_header "Arquivo: $(basename_safe "$file")  >  Seção: $section"
    render_tabs "$file"

    print_package_preview "$file" "$section"

    local choices=(
      "✏️ Editar seleção"
      "🔎 Filtrar nesta seção"
      "✅ Ativar todos da seção"
      "🚫 Desativar todos da seção"
      "↩️ Reverter seção"
      "📊 Diff deste arquivo"
      "💾 Salvar este arquivo"
      "← Voltar"
    )

    local choice
    choice="$(choose_one "Pacotes / ações" "${choices[@]}")" || return

    case "$choice" in
      "✏️ Editar seleção") ui_edit_section_packages "$file" "$section" ;;
      "🔎 Filtrar nesta seção") ui_section_filter "$file" "$section" ;;
      "✅ Ativar todos da seção") set_section_enabled "$file" "$section" 1 ;;
      "🚫 Desativar todos da seção") set_section_enabled "$file" "$section" 0 ;;
      "↩️ Reverter seção") revert_section "$file" "$section" ;;
      "📊 Diff deste arquivo") ui_diff_file "$file" ;;
      "💾 Salvar este arquivo") ui_save_file "$file" ;;
      "← Voltar") return ;;
    esac
  done
}

print_package_preview() {
  local file="$1"
  local section="$2"
  local ids=()
  collect_records "$file" "$section" ids

  local tmp="$TUINIX_TMPDIR/preview.txt"
  : > "$tmp"

  local id count=0
  for id in "${ids[@]}"; do
    ((count++)) || true
    if (( count > 12 )); then
      printf '... %s pacotes a mais\n' "$(( ${#ids[@]} - 12 ))" >> "$tmp"
      break
    fi
    printf '%s\n' "$(record_label "$id")" >> "$tmp"
  done

  style_box "$(cat "$tmp")"
  printf '\n'
}

collect_records() {
  local file="$1"
  local section="$2"
  local __out_var="$3"
  local out=()
  local id

  for id in "${!REC_FILE[@]}"; do
    [[ "${REC_FILE[$id]}" == "$file" ]] || continue
    [[ "${REC_SECTION[$id]}" == "$section" ]] || continue
    out+=("$id")
  done

  eval "$__out_var"'=()'
  local item
  for item in "${out[@]}"; do
    eval "$__out_var"'+=("$item")'
  done
}

ui_edit_section_packages() {
  local file="$1"
  local section="$2"
  local ids=()
  collect_records "$file" "$section" ids

  local -a args=()
  local id tag label status

  for id in "${ids[@]}"; do
    tag="$id"
    label="${REC_PKG[$id]}"
    if [[ -n "${REC_META[$id]}" ]]; then
      label+="  # ${REC_META[$id]}"
    fi
    if [[ "${REC_ENABLED[$id]}" == "1" ]]; then
      status="on"
    else
      status="off"
    fi
    args+=("$tag" "$label" "$status")
  done

  [[ ${#args[@]} -gt 0 ]] || return

  local selected_ids
  selected_ids="$(dialog "${DIALOG_COMMON[@]}" \
    --separate-output \
    --ok-label "Aplicar" \
    --cancel-label "Voltar" \
    --checklist "$(basename_safe "$file") > $section\n\nUse mouse, setas ou espaço para marcar/desmarcar." \
    "$TUINIX_HEIGHT" "$TUINIX_WIDTH" $(( TUINIX_HEIGHT - 8 )) \
    "${args[@]}")" || return

  local -A chosen=()
  local line
  while IFS= read -r line; do
    [[ -n "$line" ]] && chosen["$line"]=1
  done <<< "$selected_ids"

  for id in "${ids[@]}"; do
    if [[ -n "${chosen[$id]+x}" ]]; then
      REC_ENABLED[$id]=1
    else
      REC_ENABLED[$id]=0
    fi
  done

  TUINIX_LAST_STATUS="$(style_ok "Seleção atualizada em memória.")"
}

ui_section_filter() {
  local file="$1"
  local section="$2"
  local ids=()
  collect_records "$file" "$section" ids

  local tmp="$TUINIX_TMPDIR/filter-section.txt"
  : > "$tmp"

  local id
  for id in "${ids[@]}"; do
    printf '%s │ line %s │ %s\n' "${REC_PKG[$id]}" "${REC_LINE[$id]}" "$(record_state_word "$id")" >> "$tmp"
  done

  local choice
  choice="$(cat "$tmp" | filter_one "Filtrar pacote nesta seção")" || return
  [[ -n "$choice" ]] || return

  local pkg="${choice%% │ *}"
  for id in "${ids[@]}"; do
    if [[ "${REC_PKG[$id]}" == "$pkg" ]]; then
      ui_record_action "$id"
      return
    fi
  done
}

record_state_word() {
  local id="$1"
  if [[ "${REC_ENABLED[$id]}" == "1" ]]; then
    printf 'enabled'
  else
    printf 'disabled'
  fi
}

ui_record_action() {
  local id="$1"
  local file="${REC_FILE[$id]}"
  local section="${REC_SECTION[$id]}"
  local pkg="${REC_PKG[$id]}"
  local state
  state="$(record_state_word "$id")"

  render_header "Pacote: $pkg"
  cat <<EOF2
Arquivo : $(basename_safe "$file")
Seção   : $section
Linha   : ${REC_LINE[$id]}
Estado  : $state

Original:
${REC_ORIG_TEXT[$id]}

EOF2

  local choices=("🔁 Alternar" "✅ Ativar" "🚫 Desativar" "↩️ Reverter" "← Voltar")
  local choice
  choice="$(choose_one "Ação" "${choices[@]}")" || return

  case "$choice" in
    "🔁 Alternar") toggle_record "$id" ;;
    "✅ Ativar") REC_ENABLED[$id]=1 ;;
    "🚫 Desativar") REC_ENABLED[$id]=0 ;;
    "↩️ Reverter") REC_ENABLED[$id]="${REC_ENABLED_ORIG[$id]}" ;;
    *) ;;
  esac
}

set_section_enabled() {
  local file="$1"
  local section="$2"
  local value="$3"
  local ids=()
  collect_records "$file" "$section" ids
  local id
  for id in "${ids[@]}"; do
    REC_ENABLED[$id]="$value"
  done
  TUINIX_LAST_STATUS="$(style_ok "Seção atualizada em memória.")"
}

revert_section() {
  local file="$1"
  local section="$2"
  local ids=()
  collect_records "$file" "$section" ids
  local id
  for id in "${ids[@]}"; do
    REC_ENABLED[$id]="${REC_ENABLED_ORIG[$id]}"
  done
  TUINIX_LAST_STATUS="$(style_ok "Seção revertida para o estado original.")"
}

toggle_record() {
  local id="$1"
  if [[ "${REC_ENABLED[$id]}" == "1" ]]; then
    REC_ENABLED[$id]=0
  else
    REC_ENABLED[$id]=1
  fi
}

# -----------------------------------------------------------------------------
# Search UI
# -----------------------------------------------------------------------------

ui_global_search() {
  rebuild_stats

  local tmp="$TUINIX_TMPDIR/global-search.txt"
  : > "$tmp"

  local id file base state dirty meta
  for id in "${!REC_FILE[@]}"; do
    file="${REC_FILE[$id]}"
    base="$(basename_safe "$file")"
    state="$(record_state_word "$id")"
    dirty=""
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && dirty=" *"
    meta="${REC_META[$id]}"
    if [[ -n "$meta" ]]; then
      printf '%06d │ %-20s │ %-20s │ %-30s │ %s │ %s%s\n' \
        "$id" "$base" "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "$state" "$meta" "$dirty" >> "$tmp"
    else
      printf '%06d │ %-20s │ %-20s │ %-30s │ %s%s\n' \
        "$id" "$base" "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "$state" "$dirty" >> "$tmp"
    fi
  done

  render_header "Busca global"
  local choice
  choice="$(cat "$tmp" | filter_one "Digite parte do pacote, arquivo ou seção")" || return
  [[ -n "$choice" ]] || return

  if [[ "$choice" =~ ^([0-9]+)[[:space:]]*│ ]]; then
    local rid="$((10#${BASH_REMATCH[1]}))"
    ui_record_action "$rid"
  fi
}

ui_file_search() {
  local file="$1"
  local tmp="$TUINIX_TMPDIR/file-search.txt"
  : > "$tmp"

  local id state dirty meta
  for id in "${!REC_FILE[@]}"; do
    [[ "${REC_FILE[$id]}" == "$file" ]] || continue
    state="$(record_state_word "$id")"
    dirty=""
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && dirty=" *"
    meta="${REC_META[$id]}"
    if [[ -n "$meta" ]]; then
      printf '%06d │ %-20s │ %-30s │ %s │ %s%s\n' \
        "$id" "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "$state" "$meta" "$dirty" >> "$tmp"
    else
      printf '%06d │ %-20s │ %-30s │ %s%s\n' \
        "$id" "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "$state" "$dirty" >> "$tmp"
    fi
  done

  render_header "Busca em $(basename_safe "$file")"
  render_tabs "$file"
  local choice
  choice="$(cat "$tmp" | filter_one "Digite parte do pacote ou seção")" || return
  [[ -n "$choice" ]] || return

  if [[ "$choice" =~ ^([0-9]+)[[:space:]]*│ ]]; then
    local rid="$((10#${BASH_REMATCH[1]}))"
    ui_record_action "$rid"
  fi
}

# -----------------------------------------------------------------------------
# Diff / save / restore
# -----------------------------------------------------------------------------

generate_file_content() {
  local file="$1"
  local out="$2"
  local line_no=0
  local line rec_id desired

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

ui_diff_all() {
  local tmp="$TUINIX_TMPDIR/diff-all.txt"
  : > "$tmp"

  local file
  for file in "${FILES[@]}"; do
    append_diff_for_file "$file" "$tmp"
  done

  if [[ ! -s "$tmp" ]]; then
    TUINIX_LAST_STATUS="$(style_ok "Sem diferenças.")"
    return
  fi

  render_header "Diff de todos os arquivos"
  pager_text "Diff" "$tmp"
}

ui_diff_file() {
  local file="$1"
  local tmp="$TUINIX_TMPDIR/diff-one.txt"
  : > "$tmp"
  append_diff_for_file "$file" "$tmp"

  if [[ ! -s "$tmp" ]]; then
    TUINIX_LAST_STATUS="$(style_ok "Sem diferenças neste arquivo.")"
    return
  fi

  render_header "Diff: $(basename_safe "$file")"
  render_tabs "$file"
  pager_text "Diff" "$tmp"
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
  else
    diff -u -- "$file" "$newfile" >> "$diff_out" || true
  fi
  printf '\n' >> "$diff_out"
  rm -f -- "$newfile"
}

ui_save_all() {
  if ! workspace_dirty; then
    TUINIX_LAST_STATUS="$(style_ok "Nada para salvar.")"
    return
  fi

  ui_diff_all
  if ! confirm "Salvar todas as alterações?"; then
    return
  fi

  local file
  for file in "${FILES[@]}"; do
    save_file "$file"
  done

  parse_workspace
  TUINIX_LAST_STATUS="$(style_ok "Tudo salvo.")"
}

ui_save_file() {
  local file="$1"
  if ! file_dirty "$file"; then
    TUINIX_LAST_STATUS="$(style_ok "Nada para salvar neste arquivo.")"
    return
  fi

  ui_diff_file "$file"
  if ! confirm "Salvar alterações em $(basename_safe "$file")?"; then
    return
  fi

  save_file "$file"
  parse_workspace
  TUINIX_LAST_STATUS="$(style_ok "Arquivo salvo: $(basename_safe "$file")")"
}

save_file() {
  local file="$1"
  local newfile="$TUINIX_TMPDIR/save.$(basename_safe "$file").$$"
  local backup_latest="${file}${TUINIX_BACKUP_SUFFIX}"
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  local backup_stamp="${file}${TUINIX_BACKUP_SUFFIX}.${stamp}"

  generate_file_content "$file" "$newfile"

  if cmp -s "$file" "$newfile"; then
    rm -f -- "$newfile"
    return
  fi

  cp -p -- "$file" "$backup_latest"
  cp -p -- "$file" "$backup_stamp"
  mv -- "$newfile" "$file"
}

ui_restore_backup() {
  local backups=()
  local f
  for f in "${FILES[@]}"; do
    [[ -f "${f}${TUINIX_BACKUP_SUFFIX}" ]] && backups+=("$(basename_safe "$f") │ latest │ ${f}${TUINIX_BACKUP_SUFFIX}")
    while IFS= read -r -d '' b; do
      backups+=("$(basename_safe "$f") │ timestamp │ $b")
    done < <(find "$(dirname -- "$f")" -maxdepth 1 -type f -name "$(basename_safe "$f")${TUINIX_BACKUP_SUFFIX}.*" -print0 | sort -zr)
  done

  if [[ ${#backups[@]} -eq 0 ]]; then
    TUINIX_LAST_STATUS="$(style_warn "Nenhum backup encontrado.")"
    return
  fi

  render_header "Restaurar backup"
  local choice
  choice="$(choose_one "Escolha um backup" "${backups[@]}" "← Voltar")" || return
  [[ "$choice" == "← Voltar" || -z "$choice" ]] && return

  local backup="${choice##* │ }"
  local base="${choice%% │ *}"
  local target=""

  for f in "${FILES[@]}"; do
    if [[ "$(basename_safe "$f")" == "$base" ]]; then
      target="$f"
      break
    fi
  done

  [[ -n "$target" ]] || die "could not resolve backup target"

  if ! confirm "Restaurar $backup sobre $(basename_safe "$target")?"; then
    return
  fi

  cp -p -- "$backup" "$target"
  parse_workspace
  TUINIX_LAST_STATUS="$(style_ok "Backup restaurado: $(basename_safe "$target")")"
}

# -----------------------------------------------------------------------------
# Stats
# -----------------------------------------------------------------------------

ui_stats() {
  rebuild_stats

  local files_count="${#FILES[@]}"
  local sections_count packages_count active_count disabled_count dirty_count
  local -A seen_sections=()
  local id key

  sections_count=0
  packages_count="${#REC_FILE[@]}"
  active_count=0
  dirty_count=0

  for id in "${!REC_FILE[@]}"; do
    key="${REC_FILE[$id]}|${REC_SECTION[$id]}"
    if [[ -z "${seen_sections[$key]+x}" ]]; then
      seen_sections[$key]=1
      ((sections_count++)) || true
    fi
    [[ "${REC_ENABLED[$id]}" == "1" ]] && ((active_count++)) || true
    [[ "${REC_ENABLED[$id]}" != "${REC_ENABLED_ORIG[$id]}" ]] && ((dirty_count++)) || true
  done
  disabled_count=$(( packages_count - active_count ))

  local tmp="$TUINIX_TMPDIR/stats.txt"
  {
    printf 'Workspace\n'
    printf '%s\n' '---------'
    printf 'Arquivos      : %s\n' "$files_count"
    printf 'Seções        : %s\n' "$sections_count"
    printf 'Pacotes       : %s\n' "$packages_count"
    printf 'Ativos        : %s\n' "$active_count"
    printf 'Desativados   : %s\n' "$disabled_count"
    printf 'Alterados     : %s\n' "$dirty_count"
    printf '\nPor arquivo\n'
    printf '%s\n' '-----------'
    local f
    for f in "${FILES[@]}"; do
      printf '%-36s %4s/%-4s active %s\n' \
        "$(basename_safe "$f")" \
        "${FILE_ACTIVE[$f]:-0}" \
        "${FILE_TOTAL[$f]:-0}" \
        "$([[ "${FILE_DIRTY[$f]:-0}" == "1" ]] && printf '*' || true)"
    done
  } > "$tmp"

  render_header "Estatísticas"
  style_box "$(cat "$tmp")"
  pause
}

# -----------------------------------------------------------------------------
# Optional NixOS actions
# -----------------------------------------------------------------------------

ui_nixos_actions() {
  # Reserved for V2.x/V3. Kept separate so the monolith has a stable extension
  # point without changing core navigation.
  if ! has_cmd nixos-rebuild; then
    TUINIX_LAST_STATUS="$(style_warn "nixos-rebuild não encontrado.")"
    return
  fi

  local choices=("🔨 nixos-rebuild build" "🚀 nixos-rebuild switch" "← Voltar")
  local choice
  choice="$(choose_one "NixOS" "${choices[@]}")" || return

  case "$choice" in
    "🔨 nixos-rebuild build") sudo nixos-rebuild build ;;
    "🚀 nixos-rebuild switch") sudo nixos-rebuild switch ;;
    *) ;;
  esac
}

# -----------------------------------------------------------------------------
# Self-test helpers
# -----------------------------------------------------------------------------

selftest_parser() {
  local sample="$TUINIX_TMPDIR/sample.nix"
  cat > "$sample" <<'NIX'
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #▐▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🅃🅃🅈   ▀
    screen # terminal multiplexer
    tio # https://github.com/tio/tio Connect to TTY
    # bootterm # disabled terminal
    #▐▄▄▄▄▄▄▄▄▄▄▄▌

    # Hardware
    cpu-x
    # gpu-viewer
    pciutils # PCI utilities

    # File Systems 🏁
    squashfsTools
  ];
}
NIX

  FILES=("$sample")
  FILE_INDEX=(["$sample"]=0)
  parse_workspace
  printf 'records=%s\n' "${#REC_FILE[@]}"
  local id
  for id in "${!REC_FILE[@]}"; do
    printf '%s|%s|%s|%s\n' "${REC_SECTION[$id]}" "${REC_PKG[$id]}" "${REC_ENABLED[$id]}" "${REC_META[$id]}"
  done
}

# Hidden command for development:
#   TUINIX_SELFTEST=1 ./tuinix.sh
if [[ "${TUINIX_SELFTEST:-0}" == "1" ]]; then
  init_runtime
  selftest_parser
  exit 0
fi

main "$@"
