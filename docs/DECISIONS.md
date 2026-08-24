# Décisions d'architecture et de travail

> Document de référence pour le chantier de nettoyage et de restructuration de `nixos-config`.

## 1. Objectif général

- Rendre le dépôt aussi propre, cohérent et maintenable que possible, même si cela demande une restructuration importante.
- Ne pas accumuler de solutions temporaires ou de compromis uniquement pour avancer plus vite.
- Lorsqu'une restructuration est nécessaire, la faire réellement plutôt que de conserver une architecture devenue incohérente.
- Le résultat doit rester propre aussi bien pour le ZenBook-13 que, à terme, pour d'autres machines.

## 2. Organisation de la configuration

La configuration doit distinguer clairement plusieurs niveaux de responsabilité :

- **commun** : ce qui est réellement partagé par toutes les machines concernées ;
- **machine / hôte** : ce qui dépend d'une machine précise ;
- **type de machine** : ce qui dépend d'une catégorie matérielle, par exemple les laptops ;
- **propriétaire / utilisateur** : ce qui appartient à la personne qui utilise ou possède la machine ;
- **Home Manager** : configuration personnelle de l'environnement utilisateur ;
- **secrets** : données sensibles qui doivent rester séparées de la configuration commune.

Une configuration ne doit entrer dans `common` que si elle est réellement commune.

## 3. Laptops et fonctionnalités spécifiques

- Les fonctionnalités propres aux laptops ne doivent pas être imposées aux machines qui ne sont pas des laptops.
- La gestion de la batterie doit être portée par une couche dédiée aux laptops plutôt que par `common`.
- Cette couche pourra accueillir d'autres fonctionnalités spécifiques aux laptops plus tard.
- Ne pas ajouter maintenant des fonctionnalités hypothétiques uniquement pour préparer la structure : la structure doit simplement permettre de les ajouter proprement lorsque le besoin apparaîtra.

## 4. Machines et propriétaires

Une machine et son propriétaire ne sont pas la même notion.

- Le **ZenBook-13** est la machine principale actuellement traitée.
- Le **V145-15AST** est un ordinateur familial et n'est pas considéré comme la machine personnelle de Thibaut.
- Le V145-15AST reste volontairement en bas de la liste des priorités.
- Lorsqu'il sera traité, il devra pouvoir utiliser la même architecture commune sans que sa configuration suppose qu'il appartient à Thibaut.
- L'architecture doit pouvoir accueillir plusieurs propriétaires sans copier toute la configuration commune.

## 5. Utilisateurs et Home Manager

- Les utilisateurs doivent être séparés des définitions purement machine.
- Le profil utilisateur de Thibaut ne doit pas être placé dans `common`.
- Les éléments personnels, notamment l'identité Git, doivent être déclarés dans le profil Home Manager du propriétaire concerné.
- Le V145-15AST devra probablement utiliser Home Manager lorsqu'il sera restructuré afin de permettre une séparation propre entre la machine et ses utilisateurs.
- La présence de plusieurs propriétaires doit être prévue architecturalement, sans imposer dès maintenant la création de profils inutiles.

## 6. Git

- La configuration Git réellement commune peut rester dans un module commun, par exemple la branche par défaut `main`.
- Le nom et l'adresse e-mail Git sont des informations personnelles et doivent être dans le profil utilisateur/Home Manager du propriétaire.
- Les informations personnelles ne doivent donc pas être supprimées, mais déplacées au bon niveau de configuration.

## 7. Secrets

- Les secrets sont une préoccupation distincte de la configuration commune.
- Le ZenBook-13 utilise déjà une organisation de secrets qui fonctionne et il ne faut pas la casser au cours de la restructuration.
- Si une configuration commune doit être partagée avec le V145-15AST ou avec d'autres propriétaires, l'architecture des secrets devra permettre ce partage sans exposer ou mélanger inutilement les secrets personnels.
- La restructuration des secrets doit être étudiée avec soin et ne doit pas être refaite à l'aveugle.

## 8. Priorité du chantier

1. Nettoyer et structurer correctement la configuration du ZenBook-13.
2. Séparer les couches communes, machine, laptop, utilisateur et Home Manager.
3. Conserver une architecture permettant d'accueillir plusieurs propriétaires.
4. Traiter la question des secrets lorsque la structure nécessaire est en place.
5. Traiter le V145-15AST en dernier, en réutilisant la structure commune si cela est pertinent.
6. Effectuer une vérification globale avant intégration.

Cet ordre est une priorité de travail et peut évoluer si une dépendance technique l'exige.

## 9. Branche et intégration

- Le chantier se fait sur **`refactor/clean-structure`** tant qu'il n'est pas terminé.
- **`main` ne doit recevoir aucune écriture directe** dans notre processus de travail.
- Il n'y aura **pas de PR intermédiaire** pour ce chantier.
- Une **seule PR finale** sera ouverte lorsque l'ensemble du nettoyage sera terminé et vérifié.

## 10. Historique Git

- Les commits du chantier doivent être rédigés **en français**.
- Chaque commit doit avoir une **description explicative**, pas seulement un titre.
- Les commits doivent être suffisamment ciblés pour permettre de retracer l'origine et la raison d'un changement.
- Plusieurs commits cohérents sont préférables à un énorme commit mélangeant des responsabilités différentes.
- L'historique de travail précédent contenait des commits en anglais et sans descriptions suffisantes.
- La décision actuelle est de **repartir proprement depuis `main` pour le chantier de refactor**, car les décisions d'architecture ont évolué et il est préférable de reconstruire un historique cohérent plutôt que de préserver l'ancien historique de travail.
- Cette décision concerne uniquement la branche de travail et ne doit jamais entraîner une écriture sur `main`.

## 11. Méthode de travail

Avant chaque étape :

- lire **`docs/DECISIONS.md`** ;
- vérifier les décisions déjà prises dans ce document et dans la conversation ;
- annoncer clairement les fichiers ou zones qui vont être touchés ;
- traiter un bloc fonctionnel jusqu'à son état cohérent plutôt que de laisser volontairement une tâche à moitié terminée ;
- faire plusieurs commits lorsque le bloc contient plusieurs changements logiquement distincts.

Pour les vérifications en ligne et les contrôles techniques nécessaires au chantier, il n'est pas nécessaire de demander une approbation à chaque fois : ils doivent être effectués automatiquement lorsqu'ils sont utiles.

Après chaque modification :

- vérifier que les fichiers attendus ont bien été modifiés ;
- vérifier que le changement obtenu correspond à la décision prévue ;
- vérifier que rien n'a été accidentellement perdu ;
- vérifier l'état Git et, lorsque c'est pertinent, la construction/CI ;
- ne pas considérer une étape comme terminée sans cette vérification.

## 12. Règle de cohérence

Si une décision précédente existe déjà, elle doit être relue avant de proposer ou d'appliquer une modification susceptible de la contredire.

Si une décision doit finalement être changée, le changement doit être explicite et le présent document doit être mis à jour afin de conserver une trace de la nouvelle décision.
