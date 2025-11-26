#!/bin/bash
# Script pour copier les fichiers JSON sur Heroku et exécuter l'import
# Utilise cat pour copier les fichiers directement

echo "📤 Copie des fichiers JSON sur Heroku..."

# Créer le dossier tmp sur Heroku
heroku run "mkdir -p tmp" -a tubenplay-app

# Copier chaque fichier en utilisant cat
echo "📤 Copie de games_export_unique.json..."
cat tmp/games_export_unique.json | heroku run "cat > tmp/games_export_unique.json" -a tubenplay-app

echo "📤 Copie de swipes_export_unique.json..."
cat tmp/swipes_export_unique.json | heroku run "cat > tmp/swipes_export_unique.json" -a tubenplay-app

echo "📤 Copie de scores_export_unique.json..."
cat tmp/scores_export_unique.json | heroku run "cat > tmp/scores_export_unique.json" -a tubenplay-app

echo "📤 Copie de user_badges_export_unique.json..."
cat tmp/user_badges_export_unique.json | heroku run "cat > tmp/user_badges_export_unique.json" -a tubenplay-app

echo "📤 Copie de users_export.json..."
cat tmp/users_export.json | heroku run "cat > tmp/users_export.json" -a tubenplay-app

echo "📤 Copie de import_to_heroku_simple.rb..."
cat import_to_heroku_simple.rb | heroku run "cat > import_to_heroku_simple.rb" -a tubenplay-app

echo "✅ Tous les fichiers sont copiés !"
echo ""
echo "🔍 Vérification des fichiers copiés..."
heroku run "ls -lh tmp/*.json import_to_heroku_simple.rb 2>&1" -a tubenplay-app
echo ""
echo "📝 Exécution de l'import..."
heroku run "rails runner import_to_heroku_simple.rb" -a tubenplay-app

echo ""
echo "🎉 Import terminé !"

