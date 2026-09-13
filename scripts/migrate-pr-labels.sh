#!/usr/bin/env bash
set -euo pipefail

REPOSITORY="${REPOSITORY:-tbracquart/nixos-config}"
MODE="dry-run"

usage() {
  cat <<EOF
Usage: $0 [--dry-run|--apply]

Analyse les pull requests et ajoute les labels de la convention actuelle.
--dry-run est le mode par défaut et ne modifie rien.
EOF
}

case "${1:---dry-run}" in
  --dry-run) ;;
  --apply) MODE="apply" ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

command -v gh >/dev/null || { echo "Erreur : gh est requis." >&2; exit 1; }
command -v jq >/dev/null || { echo "Erreur : jq est requis." >&2; exit 1; }
gh auth status >/dev/null

classify_type() {
  local title="${1,,}"

  case "$title" in
    feat:*|feat\(*|feature:*|feature\(*) echo "type: feature"; return ;;
    fix:*|fix\(*|bugfix:*|bugfix\(*|hotfix:*|hotfix\(*) echo "type: bug"; return ;;
    docs:*|docs\(*|doc:*|doc\(*) echo "type: documentation"; return ;;
    security:*|security\(*|sec:*|sec\(*) echo "type: security"; return ;;
    ci:*|ci\(*|build:*|build\(*|chore:*|chore\(*|refactor:*|refactor\(*|perf:*|perf\(*|test:*|test\(*) echo "type: maintenance"; return ;;
  esac

  if [[ "$title" =~ (^|[^[:alpha:]])(fix|fixed|fixe|corrig|corriger|correction|répare|réparer|restore|restaurer)([^[:alpha:]]|$) ]]; then
    echo "type: bug"; return
  fi

  if [[ "$title" =~ (^|[^[:alpha:]])(documentation|documenter|readme|docs?)([^[:alpha:]]|$) ]]; then
    echo "type: documentation"; return
  fi

  if [[ "$title" =~ (^|[^[:alpha:]])(security|sécurité|secure|sécuriser)([^[:alpha:]]|$) ]]; then
    echo "type: security"; return
  fi

  if [[ "$title" =~ (^|[^[:alpha:]])(add|ajout|ajouter|rajout|enable|activer|activation|introduce|introduire|implement|implémenter|support|améliorer|improve|nouvelle?|new|feature|wrapper)([^[:alpha:]]|$) ]]; then
    echo "type: feature"; return
  fi

  echo "type: maintenance"
}


classify_title_areas() {
  local title="${1,,}"

  [[ "$title" =~ (^|[^[:alpha:]])(ci|github.actions|github-actions|workflow)([^[:alpha:]]|$) ]] && echo "area: ci" || true
  [[ "$title" =~ (^|[^[:alpha:]])(installer|installateur|iso)([^[:alpha:]]|$) ]] && echo "area: installer" || true
  [[ "$title" =~ (^|[^[:alpha:]])(noctalia|hyprland|niri|waybar|desktop)([^[:alpha:]]|$) ]] && echo "area: desktop" || true
  [[ "$title" =~ (^|[^[:alpha:]])(fish|shell)([^[:alpha:]]|$) ]] && echo "area: shell" || true
  [[ "$title" =~ (^|[^[:alpha:]])(nix|nixos|flake|polkit|pkexec|cachix)([^[:alpha:]]|$) ]] && echo "area: nix" || true
  [[ "$title" =~ zenbook[-[:space:]]?13 ]] && echo "host: zenbook-13" || true
  [[ "$title" =~ v145[-[:space:]]?15ast ]] && echo "host: v145-15ast" || true
}

classify_areas() {
  local files="$1"

  grep -q '^\.github/' <<<"$files" && echo "area: ci" || true
  grep -qiE '(^|/)(installer|install)(/|$)|(^|/)iso|isoimage' <<<"$files" && echo "area: installer" || true
  grep -qE '^(flake\.nix|flake\.lock|common/|modules/|profiles/|hosts/)' <<<"$files" && echo "area: nix" || true
  grep -qiE '(^|/)(fish|dotfiles/fish)(/|$)|\.fish$' <<<"$files" && echo "area: shell" || true
  grep -qiE 'noctalia|hyprland|niri|waybar|desktop|gimp' <<<"$files" && echo "area: desktop" || true
  grep -q '^hosts/ZenBook-13/' <<<"$files" && echo "host: zenbook-13" || true
  grep -q '^hosts/V145-15AST/' <<<"$files" && echo "host: v145-15ast" || true
}

gh pr list --repo "$REPOSITORY" --state all --limit 1000 \
  --json number,title,labels,files |
jq -r '.[] | @base64' |
while IFS= read -r encoded; do
  pr="$(printf '%s' "$encoded" | base64 --decode)"
  number="$(jq -r '.number' <<<"$pr")"
  title="$(jq -r '.title' <<<"$pr")"
  existing="$(jq -r '.labels[].name' <<<"$pr")"
  files="$(jq -r '.files[].path' <<<"$pr")"

  labels=("$(classify_type "$title")")
  while IFS= read -r label; do
    [[ -n "$label" ]] && labels+=("$label")
  done < <(classify_title_areas "$title")
  while IFS= read -r label; do
    [[ -n "$label" ]] && labels+=("$label")
  done < <(classify_areas "$files")

  declare -A seen=()
  add=()
  for label in "${labels[@]}"; do
    [[ -n "${seen[$label]:-}" ]] && continue
    seen[$label]=1
    grep -Fxq "$label" <<<"$existing" || add+=("$label")
  done

  (("${#add[@]}")) || continue

  printf '#%s %s\n  + %s\n' "$number" "$title" "$(IFS=', '; echo "${add[*]}")"

  if [[ "$MODE" == "apply" ]]; then
    args=()
    for label in "${add[@]}"; do
      args+=(--add-label "$label")
    done
    gh pr edit "$number" --repo "$REPOSITORY" "${args[@]}"
  fi
done
