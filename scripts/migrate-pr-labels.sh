#!/usr/bin/env bash
set -euo pipefail

REPOSITORY="${REPOSITORY:-tbracquart/nixos-config}"
MODE="dry-run"

case "${1:---dry-run}" in
  --dry-run) ;;
  --apply) MODE="apply" ;;
  -h|--help)
    echo "Usage: $0 [--dry-run|--apply]"
    exit 0 ;;
  *) echo "Usage: $0 [--dry-run|--apply]" >&2; exit 2 ;;
esac

command -v gh >/dev/null || { echo "Erreur : gh est requis." >&2; exit 1; }
command -v jq >/dev/null || { echo "Erreur : jq est requis." >&2; exit 1; }
gh auth status >/dev/null

gh pr list --repo "$REPOSITORY" --state all --limit 1000   --json number,title,labels,files |
jq -r '.[] | @base64' |
while IFS= read -r encoded; do
  pr="$(printf '%s' "$encoded" | base64 --decode)"
  number="$(jq -r '.number' <<<"$pr")"
  title="$(jq -r '.title' <<<"$pr")"
  lower="${title,,}"

  labels=()
  case "$lower" in
    feat:*|feat\(*) labels+=("type: feature") ;;
    fix:*|fix\(*) labels+=("type: bug") ;;
    docs:*|docs\(*) labels+=("type: documentation") ;;
    security:*|security\(*) labels+=("type: security") ;;
    *) labels+=("type: maintenance") ;;
  esac

  files="$(jq -r '.files[].path' <<<"$pr")"
  grep -q '^\.github/' <<<"$files" && labels+=("area: ci") || true
  grep -qE '(^|/)installer|iso' <<<"$files" && labels+=("area: installer") || true
  grep -qE '^(flake\.nix|flake\.lock|common/|modules/|profiles/|hosts/)' <<<"$files" && labels+=("area: nix") || true
  grep -qE 'fish|dotfiles/fish' <<<"$files" && labels+=("area: shell") || true
  grep -qiE 'noctalia|hyprland|niri|desktop' <<<"$files" && labels+=("area: desktop") || true
  grep -q '^hosts/ZenBook-13/' <<<"$files" && labels+=("host: zenbook-13") || true
  grep -q '^hosts/V145-15AST/' <<<"$files" && labels+=("host: v145-15ast") || true

  existing="$(jq -r '.labels[].name' <<<"$pr")"
  add=()
  for label in "${labels[@]}"; do
    grep -Fxq "$label" <<<"$existing" || add+=("$label")
  done

  (("${#add[@]}")) || continue
  printf '#%s %s\n  + %s\n' "$number" "$title" "$(IFS=', '; echo "${add[*]}")"

  if [[ "$MODE" == apply ]]; then
    args=()
    for label in "${add[@]}"; do args+=(--add-label "$label"); done
    gh pr edit "$number" --repo "$REPOSITORY" "${args[@]}"
  fi
done
