## 📝 Description

### 🎯 Objectif
<!-- Pourquoi cette PR existe-t-elle ? Quel problème résout-elle ou quel est le but recherché ? (ex: corriger un bug de batterie, ajouter un raccourci, etc.) -->
- 

### 🛠️ Changements apportés
<!-- Qu'avez-vous modifié concrètement ? -->
- 

<!-- S'il s'agit d'un changement visuel (Modifications du shell graphique Noctalia, widgets, configuration Hyprland), incluez une capture d'écran ou un GIF ci-dessous -->

## 🔗 Ticket & Contexte

Résout # <!-- Indiquez le numéro de l'issue si existante, sinon laissez vide -->

## ⚠️ Impact SemVer (Obligatoire)

*Veuillez cocher **une seule** case pour indiquer l'impact de cette PR sur la version globale du dépôt :*

- [ ] 🚨 **major** : Changement incompatible avec l'architecture ou les conventions stables.
- [ ] 🚀 **minor** : Nouvelle fonctionnalité compatible (ex: nouveau profil, nouveau module my.*).
- [ ] 🐛 **patch** : Correction, maintenance, mise à jour des paquets, sécurité ou documentation.
- [ ] ⏩ **release: skip** : Changement explicitement exclu du versionnement automatique.

## 🖥 Hôtes et Modules impactés

*Cochez les zones touchées par vos modifications :*

- **Hôtes :** [ ] `ZenBook-13` | [ ] `V145-15AST` | [ ] `installer` (ISO)
- **Configuration Nix :** [ ] `common/` | [ ] `modules/` (`my.*`) | [ ] `profiles/` | [ ] `flake.nix`
- **Utilisateurs & Environnement :** [ ] Configuration `thibaut` | [ ] Configuration `quentin`
- **Composants Graphiques & Commandes :** [ ] Shell graphique `Noctalia` | [ ] Compositeur `Hyprland` | [ ] Interpréteur de commandes `Fish`
- **Autre :** [ ] CI / Workflows (GitHub Actions)

## 🧪 Protocole de Test

### 🤖 Vérifications Automatiques (CI)
*(À laisser décoché si les modifications ne touchent pas à l'évaluation Nix / Flakes)*
- [ ] Le workflow GitHub Actions **NixOS CI** est passé au vert 🟢
- [ ] L'évaluation complète du Flake a réussi sans erreur sur la CI.

### 💻 Vérifications Locales
*Sélectionnez le protocole correspondant à la nature de vos modifications :*

#### ❄️ Option A : Changements Nix / Système / Modules
- [ ] **Évaluation simple :** La commande `nix flake check` passe avec succès.
- [ ] **Test de build (simulation dry-run) :** La commande `sudo nixos-rebuild dry-activate --flake ~/nixos-config#<Hôte>` a réussi.
- [ ] **Déploiement complet :** Appliqué localement avec succès via vos fonctions Fish (`rebuild` ou `update`).

#### 🎨 Option B : Changements utilisateur (Dotfiles, Shell graphique Noctalia, Raccourcis Hyprland...)
- [ ] **Rendu visuel & Relance :** Le shell graphique `Noctalia` ou le compositeur `Hyprland` a été relancé avec succès.
- [ ] Les modifications s'appliquent correctement à la session utilisateur et le comportement attendu est validé.
- [ ] Aucun plantage ou blocage constaté lors de l'application directe de la configuration.

### 📝 Notes de test
<!-- Optionnel : Précisez ici comment vous avez validé les changements (ex: testé en direct sur le ZenBook-13, ajustement des widgets Noctalia, etc.) -->

## ✅ Checklist avant fusion

- [ ] La structure logique a été respectée (séparation stricte entre `common/`, `modules/`, `profiles/` et `hosts/`).
- [ ] La configuration reste entièrement déclarative et reproductible.
- [ ] J'ai appliqué les labels appropriés sur la PR (`area:*`, `host:*`, `dependencies`, etc.).
