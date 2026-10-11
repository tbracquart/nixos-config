#!/usr/bin/env bash
set -Eeuo pipefail

readonly SYSTEM_PROFILE="/nix/var/nix/profiles/system"
readonly CURRENT_SYSTEM="/run/current-system"

need_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Commande introuvable : %s\n' "$1" >&2
    exit 127
  }
}

pause() {
  printf '\nAppuie sur Entrée pour continuer…'
  read -r _
}

show_overview() {
  printf '\n== Espace disque ==\n'
  df -h / /nix/store 2>/dev/null || df -h /

  printf '\n== Générations système ==\n'
  sudo nix-env --profile "$SYSTEM_PROFILE" --list-generations

  printf '\n== Taille de la fermeture système actuelle ==\n'
  nix path-info -Sh "$CURRENT_SYSTEM" 2>/dev/null || true

  printf '\n== Prévisualisation du ramasse-miettes ==\n'
  printf 'Nix va indiquer les chemins qui seraient supprimés, sans les supprimer.\n'
  sudo nix store gc --dry-run
}

preview_gc() {
  printf '\nPrévisualisation du nettoyage : aucun chemin ne sera supprimé.\n\n'
  sudo nix store gc --dry-run
}

run_gc() {
  printf '\nLe ramasse-miettes supprimera les chemins inutilisés du magasin Nix.\n'
  printf 'Les générations encore référencées ne sont normalement pas supprimées par cette action.\n'
  read -r -p 'Lancer le nettoyage ? [o/N] ' answer
  case "$answer" in
    o|O|oui|OUI)
      sudo nix store gc
      ;;
    *)
      printf 'Nettoyage annulé.\n'
      ;;
  esac
}

run_optimise() {
  printf '\nL’optimisation déduplique les fichiers identiques du magasin Nix.\n'
  printf 'Elle peut prendre du temps et ne supprime pas les générations.\n'
  read -r -p 'Lancer l’optimisation ? [o/N] ' answer
  case "$answer" in
    o|O|oui|OUI)
      sudo nix store optimise
      ;;
    *)
      printf 'Optimisation annulée.\n'
      ;;
  esac
}

check_flake() {
  local repo
  repo="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    printf 'Aucun dépôt Git détecté depuis le répertoire courant.\n' >&2
    printf 'Place-toi dans ton dépôt nixos-config puis relance cette option.\n'
    return 1
  }

  printf 'Vérification du flake dans : %s\n' "$repo"
  nix flake check "$repo"
}

show_generations() {
  printf '\nGénérations système (aucune suppression effectuée) :\n'
  sudo nix-env --profile "$SYSTEM_PROFILE" --list-generations
  printf '\nPour conserver le contrôle des retours arrière, la suppression des générations se fait volontairement hors de cet outil.\n'
  printf 'Consulte la documentation avec : nix-collect-garbage --help\n'
}

main_menu() {
  need_command nix
  need_command sudo

  while true; do
    printf '\n'
    printf '╭─ Assistant de maintenance NixOS ─────────────╮\n'
    printf '│  1. Analyser le système                      │\n'
    printf '│  2. Prévisualiser le nettoyage               │\n'
    printf '│  3. Nettoyer les chemins inutilisés          │\n'
    printf '│  4. Optimiser le magasin Nix                 │\n'
    printf '│  5. Examiner les générations                 │\n'
    printf '│  6. Vérifier le flake du dépôt courant       │\n'
    printf '│  0. Quitter                                  │\n'
    printf '╰──────────────────────────────────────────────╯\n'
    read -r -p 'Choix : ' choice

    case "$choice" in
      1) show_overview; pause ;;
      2) preview_gc; pause ;;
      3) run_gc; pause ;;
      4) run_optimise; pause ;;
      5) show_generations; pause ;;
      6) check_flake; pause ;;
      0) exit 0 ;;
      *) printf 'Choix invalide.\n' ;;
    esac
  done
}

main_menu "$@"
