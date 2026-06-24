#!/usr/bin/env bash

set -euo pipefail

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

find_nix_files() {
    if [[ $# -gt 0 ]]; then
        printf "%s\n" "$@"
    else
        find . -maxdepth 1 -name "*.nix" | sort
    fi
}

extract_packages() {
    local file="$1"

    awk '
    /environment\.systemPackages/ { inside=1; next }

    inside && /\]/ { inside=0; exit }

    inside {
        line=$0

        active=1
        if (match(line,/^[[:space:]]*#/)) {
            active=0
        }

        gsub(/^[[:space:]]*#?[[:space:]]*/,"",line)

        if (match(line,/^[A-Za-z0-9._+-]+/)) {
            pkg=substr(line,RSTART,RLENGTH)
            print pkg "|" active
        }
    }
    ' "$file"
}

update_file() {
    local file="$1"
    shift

    declare -A selected

    for pkg in "$@"; do
        selected["$pkg"]=1
    done

    awk -v selections="$(printf "%s\n" "$@" | paste -sd, -)" '
    BEGIN {
        split(selections,a,",")
        for(i in a) wanted[a[i]]=1
    }

    /environment\.systemPackages/ {
        inside=1
        print
        next
    }

    inside && /\]/ {
        inside=0
        print
        next
    }

    inside {
        orig=$0

        tmp=orig
        gsub(/^[[:space:]]*#?[[:space:]]*/,"",tmp)

        if (match(tmp,/^[A-Za-z0-9._+-]+/)) {
            pkg=substr(tmp,RSTART,RLENGTH)

            indent=""
            match(orig,/^[[:space:]]*/)
            indent=substr(orig,RSTART,RLENGTH)

            if (wanted[pkg]) {
                print indent pkg
            } else {
                print indent "# " pkg
            }
            next
        }
    }

    {
        print
    }
    ' "$file" > "$file.tmp"

    mv "$file.tmp" "$file"
}

process_file() {
    local file="$1"

    mapfile -t entries < <(extract_packages "$file")

    if [[ ${#entries[@]} -eq 0 ]]; then
        echo "Nenhum pacote encontrado em $file"
        return
    fi

    declare -a defaults=()
    declare -a packages=()

    for e in "${entries[@]}"; do
        pkg="${e%%|*}"
        active="${e##*|}"

        packages+=("$pkg")

        if [[ "$active" == "1" ]]; then
            defaults+=("$pkg")
        fi
    done

    echo
    echo "Arquivo: $file"
    echo

    selected=$(
        gum choose \
            --no-limit \
            "${defaults[@]/#/--selected=}" \
            "${packages[@]}"
    )

    mapfile -t chosen <<< "$selected"

    update_file "$file" "${chosen[@]}"

    echo "Atualizado: $file"
}

main() {
    mapfile -t files < <(find_nix_files "$@")

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "Nenhum .nix encontrado"
        exit 1
    fi

    for file in "${files[@]}"; do
        process_file "$file"
    done
}

main "$@"