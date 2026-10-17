# OpenClaw

OpenClaw est installé de manière déclarative par Home Manager avec
[nix-openclaw](https://github.com/openclaw/nix-openclaw). Son Gateway tourne
comme service systemd utilisateur et n'écoute qu'en local. Le plugin runtime
`codex` est installé et activé par Nix pour permettre l'utilisation du moteur
Codex avec l'authentification OAuth OpenAI.

Le paquet Codex de la version verrouillée de `nix-openclaw` annonce encore
`./index.ts` dans son manifeste alors que le paquet publié ne fournit que
l'entrée compilée `./dist/index.js`. L'overlay dans `common/default.nix`
corrige ce chemin dans le paquet construit, afin qu'OpenClaw ne le rejette pas
avec `missing-extension-entry`. Retirer cet overlay lorsque le correctif
amont sera intégré.

## Préparer les secrets

Aucun jeton ne doit être ajouté au dépôt ou stocké dans le magasin Nix.

Créer le répertoire privé et le jeton d'accès au Gateway :

```fish
install -d -m 700 ~/.secrets
openssl rand -hex 32 > ~/.secrets/openclaw-gateway-token
chmod 600 ~/.secrets/openclaw-gateway-token
```

Créer un bot Telegram avec [@BotFather](https://t.me/BotFather), puis enregistrer
son jeton sans l'afficher dans le terminal :

```fish
read -s -P 'Jeton Telegram : ' token
printf '%s' "$token" > ~/.secrets/openclaw-telegram-token
set -e token
chmod 600 ~/.secrets/openclaw-telegram-token
```

## Activer et connecter le modèle

Après fusion de la PR :

1. Exécuter `rebuild` pour appliquer la configuration.
2. Connecter le compte ChatGPT/Codex par OAuth, sans clé API :
   `openclaw models auth login --provider openai`.
3. Vérifier l'accès avec `openclaw models status` et l'état du service avec
   `systemctl --user status openclaw-gateway`.
4. Ouvrir l'interface locale avec `openclaw dashboard` et envoyer un message
   pour confirmer qu'une vraie réponse est générée.

Le modèle configuré est `openai/gpt-6-astra`. Le runtime Codex est installé
déclarativement par `programs.openclaw.runtimePlugins`, qui active également
son entrée de configuration. L'authentification OAuth utilise le quota Codex
éventuellement disponible avec le compte ChatGPT : elle ne crée pas de
facturation API séparée. L'accès au modèle et le quota dépendent toutefois de
l'éligibilité du compte. En cas d'indisponibilité, consulter
`openclaw models list --provider openai` avant de changer le modèle dans
`users/thibaut/base/04-openclaw.nix`.

## Telegram

Envoyer un premier message privé au bot. Avec la politique `pairing`, un
nouveau correspondant doit être explicitement approuvé :

```fish
openclaw pairing approve telegram <code>
```

Ne pas exposer le Gateway sur Internet. Le service local et le jumelage Telegram
sont intentionnels ; le jeton du bot et celui du Gateway restent hors de Git.
