[![NixOS CI](https://github.com/tbracquart/nixos-config/actions/workflows/check.yml/badge.svg)](https://github.com/tbracquart/nixos-config/actions/workflows/check.yml) [![Update flake](https://github.com/tbracquart/nixos-config/actions/workflows/update.yml/badge.svg)](https://github.com/tbracquart/nixos-config/actions/workflows/update.yml)

# ❄️ NixOS Config

Configuration personnelle NixOS gérée avec **Nix Flakes** et **Home Manager**.
Le dépôt sépare la configuration système commune, les fonctionnalités réutilisables, les profils de machines, les particularités des hôtes et les environnements utilisateurs.

## 💿 Télécharger l'installateur NixOS

> **Vous cherchez l'ISO d'installation ? Pas besoin de parcourir toutes les releases.**

### 🚀 [Télécharger la dernière ISO d'installation](https://github.com/tbracquart/nixos-config/releases/tag/installer-latest)

Cette page pointe toujours vers **la dernière ISO générée depuis `main`**.

📥 **[Téléchargement direct de l'ISO actuelle](https://github.com/tbracquart/nixos-config/releases/download/installer-latest/nixos-minimal-26.11.20260905.c043004-x86_64-linux.iso)**

---

## 🖥️ Hôtes

| Hôte | Configuration |
|---|---|
| **ZenBook-13** | ASUS ZenBook 13 — NixOS unstable, Limine, noyau CachyOS BORE, Hyprland + Noctalia |
| **V145-15AST** | Lenovo V145-15AST — NixOS unstable, systemd-boot, Plasma 6 |

Home Manager est intégré aux deux configurations. Thibaut est configuré sur les deux machines et Quentin sur le V145.

## 📁 Structure

```text
.
├── common/
│   ├── system/              # Configuration NixOS réellement commune
│   └── users/               # Comptes Unix communs aux machines
├── hosts/
│   ├── ZenBook-13/          # Particularités matérielles et système du ZenBook
│   └── V145-15AST/          # Particularités matérielles et système du V145
├── modules/                 # Fonctionnalités NixOS réutilisables et leurs options my.*
├── profiles/                # Profils de machines composant plusieurs fonctionnalités
│   └── laptop.nix           # Profil commun aux ordinateurs portables
├── users/
│   ├── thibaut/             # Configuration Home Manager de Thibaut
│   └── quentin/             # Configuration Home Manager de Quentin
├── flake.nix
├── flake.lock
└── secrets/
```

La règle générale est de placer chaque élément là où se trouve sa responsabilité :

- `common/` pour ce qui doit réellement s'appliquer à toutes les machines ;
- `modules/` pour encapsuler une fonctionnalité réutilisable et déclarer son interface d'options ;
- `profiles/` pour regrouper plusieurs fonctionnalités cohérentes dans un preset de machine, comme `laptop`, `desktop` ou `server` ;
- `hosts/` pour les différences propres à une machine et les choix de configuration exposés par les modules ;
- `users/` pour la configuration Home Manager d'un utilisateur.

Le profil `laptop.nix` est chargé statiquement avec les autres modules communs, puis activé par l'hôte avec l'option lisible `my.profile = "laptop"`. Il est actuellement volontairement minimal, mais constitue le point de composition prévu pour les fonctionnalités communes aux ordinateurs portables. De nouveaux profils pourront être ajoutés sans introduire de sélection dynamique des modules.

Les hôtes composent donc le système avec des `imports` statiques, puis configurent les fonctionnalités réutilisables via leurs options `my.*`. Les modules déclarent ces options et implémentent leur comportement ; les profils fournissent des presets de configuration de plus haut niveau.

## 🧩 Principes de configuration

Les programmes sont configurés avec un module NixOS ou Home Manager lorsqu'il apporte une configuration ou un comportement supplémentaire pertinent. Un paquet reste dans `environment.systemPackages` ou `home.packages` lorsqu'aucun module utile n'est nécessaire.

La présence d'un module est donc évaluée sur ses **effets réels**, pas seulement sur le fait qu'il installe le même paquet.

Les outils d'administration système communs restent dans `common/system` lorsque leur présence est utile sur les différentes machines. Les applications de bureau personnelles, comme le terminal ou le gestionnaire de fichiers, restent dans Home Manager.

## 🖥️ Environnement utilisateur de Thibaut

- **Shell** : Fish
- **Terminal** : Alacritty
- **Gestionnaire de fichiers** : Nemo
- **Éditeur** : Geany
- **Monitoring** : btop
- **Informations système** : Fastfetch
- **Navigateur** : Firefox, installé sans personnalisation déclarative

Les extensions, thèmes et profils personnels de Firefox ne sont pas gérés par le dépôt. La connexion au compte Firefox reste une opération personnelle après une réinstallation.

## 🔐 Authentification faciale

Le dépôt utilise **Howdy** pour l'authentification faciale via PAM sur les configurations qui l'activent. Le module de base est commun aux machines compatibles, tandis que la configuration liée au capteur infrarouge est sélectionnée séparément pour le ZenBook.

## 🔊 Services système communs

La base commune configure notamment :

- PipeWire pour l'audio ;
- Avahi ;
- CUPS et HPLIP pour l'impression ;
- OpenSSH ;
- GVFS ;
- fwupd ;
- KDE Connect ;
- Fish comme shell système disponible pour les utilisateurs.

Flatpak est géré par un module réutilisable et n'est activé que sur les hôtes qui le demandent ; il est actuellement activé sur le V145.

## 🔑 Secrets et reproductibilité

Les secrets sont gérés avec **sops-nix** et ne doivent pas être stockés en clair dans Git.

Une réinstallation complète doit permettre de reconstruire la configuration NixOS et Home Manager à partir du dépôt. Les éléments qui constituent un état personnel ou une authentification de session — par exemple la connexion à un compte Firefox — sont volontairement exclus de cette reproductibilité.

Les fichiers `hardware-configuration.nix` sont générés à partir du matériel et du partitionnement de chaque machine et peuvent donc être régénérés lors d'une réinstallation.

## 🚀 Utilisation

### Prérequis

- NixOS avec les flakes activés ;
- le dépôt cloné dans `~/nixos-config`.

Le flake suit `nixos-unstable` pour NixOS et `master` pour Home Manager.

### Build manuel

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#ZenBook-13
sudo nixos-rebuild switch --flake ~/nixos-config#V145-15AST
```

Les fonctions Fish fournies par Home Manager incluent notamment `rebuild`, `update`, `upgrade`, `push` et `wait-ci`.

## ⚠️ Avertissement

Ce dépôt contient des éléments propres aux machines et aux utilisateurs, notamment des identifiants de systèmes de fichiers, des noms d'hôtes et des secrets chiffrés. Il n'est pas conçu comme un template universel : adaptez les fichiers matériels et les paramètres propres à votre installation avant toute réutilisation.
