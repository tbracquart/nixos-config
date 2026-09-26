{ ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = false;

    interactiveShellInit = ''
      fastfetch
      echo

      # Token Cachix (hors dépôt)
      if test -f ~/.config/cachix/token.fish
        source ~/.config/cachix/token.fish
      end
    '';

    functions = {
      clr = ''
        clear
        fastfetch
        echo
      '';

      wait-ci = ''
        if type -q gh
          echo ""
          echo "⏳ Attente du run CI sur $argv[1]..."
          sleep 5
          set -l run_id (gh run list --branch $argv[1] --workflow "NixOS CI" --limit 1 --json databaseId --jq '.[0].databaseId')
          if test -n "$run_id"
            gh run watch $run_id --exit-status
            and echo "✅ CI terminée et poussée vers Cachix."
            or echo "⚠️  CI échouée — un rebuild pourrait compiler en local."
          else
            echo "⚠️  Aucun run CI trouvé."
          end
        else
          echo "ℹ️  gh absent, impossible d'attendre la CI automatiquement."
        end
      '';

      push = ''
        cd $NIXCFG
        git add .
        git diff --cached
        git status
        read -l -P "Message de commit : " commit_msg

        if test -z "$commit_msg"
          echo "❌ Message de commit vide, annulation."
          return 1
        end

        git commit -m "$commit_msg"
        and begin
          set -l current_branch (git rev-parse --abbrev-ref HEAD)

          echo ""
          echo "🌿 Branches locales :"
          git branch --format='  %(refname:short)'

          echo ""
          echo "🌐 Branches distantes :"
          git branch -r --format='  %(refname:short)' | grep -v 'HEAD ->'

          echo ""
          read -l -P "Branche de push [$current_branch] : " target_branch
          if test -z "$target_branch"
            set target_branch $current_branch
          end

          if not git show-ref --verify --quiet refs/heads/$target_branch
            and not git ls-remote --exit-code --heads origin $target_branch >/dev/null 2>&1
            read -l -P "🌱 La branche '$target_branch' n'existe pas, la créer ? [y/N] " create_branch
            if test "$create_branch" = "y" -o "$create_branch" = "Y"
              git checkout -b $target_branch
            else
              echo "❌ Push annulé."
              return 1
            end
          end

          git push origin $target_branch
          and begin
            echo "✅ Push terminé sur $target_branch !"
            wait-ci $target_branch
          end
          or echo "❌ Push échoué (commit local conservé)."
        end
        or echo "❌ Commit échoué."
      '';

      update = ''
        echo "🔄 Mise à jour des Flakes..."
        cd $NIXCFG
        nix flake update
        and echo "✅ Flakes à jour !"
        or echo "❌ Mise à jour des flakes échouée."
      '';

      rebuild = ''
        set -l host (hostname)
        echo "🚀 Reconstruction de NixOS + Home Manager pour $host..."
        sudo nixos-rebuild switch --flake $NIXCFG#$host
        and begin
          echo "✅ Fini !"
          cd $NIXCFG
          if test -z "$(git status --porcelain)"
            echo "ℹ️  Rien à commit."
          else
            read -l -P "🔼 Des changements sont détectés, pousser vers le dépôt ? [y/N] " confirm
            if test "$confirm" = "y" -o "$confirm" = "Y"
              push
            else
              echo "⏸️  Push annulé."
            end
          end
        end
        or echo "❌ Rebuild échoué."
      '';

      upgrade = ''
        echo "🌟 Mise à jour complète du système 🌟"
        echo "ℹ️  Le flake.lock est déjà mis à jour chaque nuit par la CI."
        echo ""
        git -C $NIXCFG pull
        and rebuild
        and echo "🎉 Terminé !"
        or echo "❌ Upgrade interrompu."
      '';
    };
  };
}
