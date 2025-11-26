# Guide d'import des données de jeu vers Heroku

## Méthode recommandée : Copie manuelle via heroku run bash

### Étape 1 : Copier les fichiers JSON sur Heroku

1. Ouvrez une session bash sur Heroku :
```bash
heroku run bash -a tubenplay-app
```

2. Créez le dossier tmp :
```bash
mkdir -p tmp
exit
```

3. Copiez chaque fichier JSON (depuis votre terminal local) :
```bash
# Pour chaque fichier, utilisez cette commande :
cat tmp/games_export_unique.json | heroku run "cat > tmp/games_export_unique.json" -a tubenplay-app
cat tmp/swipes_export_unique.json | heroku run "cat > tmp/swipes_export_unique.json" -a tubenplay-app
cat tmp/scores_export_unique.json | heroku run "cat > tmp/scores_export_unique.json" -a tubenplay-app
cat tmp/user_badges_export_unique.json | heroku run "cat > tmp/user_badges_export_unique.json" -a tubenplay-app
cat tmp/users_export.json | heroku run "cat > tmp/users_export.json" -a tubenplay-app
```

4. Copiez le script d'import :
```bash
cat import_to_heroku_simple.rb | heroku run "cat > import_to_heroku_simple.rb" -a tubenplay-app
```

### Étape 2 : Vérifier que les fichiers sont copiés

```bash
heroku run "ls -la tmp/*.json import_to_heroku_simple.rb" -a tubenplay-app
```

### Étape 3 : Exécuter l'import

```bash
heroku run "rails runner import_to_heroku_simple.rb" -a tubenplay-app
```

## Alternative : Utiliser un script automatisé

Si la méthode manuelle ne fonctionne pas, vous pouvez utiliser le script `upload_and_import_v2.sh` :

```bash
chmod +x upload_and_import_v2.sh
./upload_and_import_v2.sh
```

## Vérification après l'import

Vérifiez que les données ont été importées :

```bash
heroku run "rails runner \"puts 'Utilisateurs: ' + User.count.to_s; puts 'Badges attribués: ' + UserBadge.count.to_s; puts 'Parties jouées: ' + Game.count.to_s; puts 'Swipes: ' + Swipe.count.to_s; puts 'Scores: ' + Score.count.to_s\"" -a tubenplay-app
```

