#!/bin/bash
# Script pour copier les fichiers JSON sur Heroku et exécuter l'import

echo "📤 Copie des fichiers JSON sur Heroku..."

# Créer le dossier tmp sur Heroku
heroku run "mkdir -p tmp" -a tubenplay-app

# Copier chaque fichier en utilisant base64
# Sur macOS, base64 utilise -i pour input, sur Linux (Heroku) c'est stdin
echo "📤 Copie de games_export_unique.json..."
base64 -i tmp/games_export_unique.json | heroku run "base64 -d > tmp/games_export_unique.json" -a tubenplay-app

echo "📤 Copie de swipes_export_unique.json..."
base64 -i tmp/swipes_export_unique.json | heroku run "base64 -d > tmp/swipes_export_unique.json" -a tubenplay-app

echo "📤 Copie de scores_export_unique.json..."
base64 -i tmp/scores_export_unique.json | heroku run "base64 -d > tmp/scores_export_unique.json" -a tubenplay-app

echo "📤 Copie de user_badges_export_unique.json..."
base64 -i tmp/user_badges_export_unique.json | heroku run "base64 -d > tmp/user_badges_export_unique.json" -a tubenplay-app

echo "📤 Copie de users_export.json..."
base64 -i tmp/users_export.json | heroku run "base64 -d > tmp/users_export.json" -a tubenplay-app

echo "📤 Copie de import_to_heroku.rb..."
base64 -i import_to_heroku.rb | heroku run "base64 -d > import_to_heroku.rb" -a tubenplay-app

echo "✅ Tous les fichiers sont copiés !"
echo ""
echo "🔍 Vérification des fichiers copiés..."
heroku run "ls -la tmp/*.json import_to_heroku.rb 2>&1 | head -10" -a tubenplay-app
echo ""
echo "📝 Exécution de l'import..."
heroku run "rails runner import_to_heroku.rb" -a tubenplay-app

echo ""
echo "🎉 Import terminé !"
