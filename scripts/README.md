# Scripts

## Migration des labels des pull requests

Le script `migrate-pr-labels.sh` analyse toutes les pull requests et ajoute les
labels correspondant à la convention actuelle.

### Aperçu

```fish
./scripts/migrate-pr-labels.sh --dry-run
```

Aucune modification n'est effectuée.

### Application

```fish
./scripts/migrate-pr-labels.sh --apply
```

Le script ajoute uniquement les labels manquants. Il ne supprime pas les labels
existants afin de permettre une vérification séparée avant le nettoyage final.
