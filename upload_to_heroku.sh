#!/bin/bash
# Script pour copier les fichiers JSON sur Heroku et exécuter l'import

echo "📤 Copie des fichiers JSON sur Heroku..."

# Créer le dossier tmp sur Heroku
heroku run "mkdir -p tmp" -a tubenplay-app

# Fonction pour copier un fichier via base64
copy_file() {
  local file=$1
  local remote_file=$2
  
  if [ ! -f "$file" ]; then
    echo "❌ Fichier manquant: $file"
    return 1
  fi
  
  echo "📤 Copie de $file..."
  base64 "$file" | heroku run "base64 -d > $remote_file" -a tubenplay-app
}

# Copier tous les fichiers
copy_file "tmp/games_export_unique.json" "tmp/games_export_unique.json"
copy_file "tmp/swipes_export_unique.json" "tmp/swipes_export_unique.json"
copy_file "tmp/scores_export_unique.json" "tmp/scores_export_unique.json"
copy_file "tmp/user_badges_export_unique.json" "tmp/user_badges_export_unique.json"
copy_file "tmp/users_export.json" "tmp/users_export.json"

echo "✅ Tous les fichiers sont copiés !"
echo ""
echo "📝 Exécution de l'import..."
heroku run "rails runner import_to_heroku.rb" -a tubenplay-app

echo ""
echo "🎉 Import terminé !"
