#!/bin/bash
# Script pour importer les données sur Heroku
# Copie le JSON et le script Ruby dans un seul dyno, puis exécute

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku..."

# Vérifier que le fichier JSON existe
if [ ! -f "tmp/all_data.json" ]; then
  echo "❌ Fichier tmp/all_data.json non trouvé"
  echo "💡 Créez-le d'abord avec: ruby -e \"require 'json'; data = {'games' => JSON.parse(File.read('tmp/games_export_unique.json')), 'swipes' => JSON.parse(File.read('tmp/swipes_export_unique.json')), 'scores' => JSON.parse(File.read('tmp/scores_export_unique.json')), 'user_badges' => JSON.parse(File.read('tmp/user_badges_export_unique.json')), 'users' => JSON.parse(File.read('tmp/users_export.json'))}; puts JSON.generate(data)\" > tmp/all_data.json"
  exit 1
fi

# Vérifier que le script Ruby existe
if [ ! -f "import_from_file.rb" ]; then
  echo "❌ Fichier import_from_file.rb non trouvé"
  exit 1
fi

echo "📤 Copie des fichiers sur Heroku dans un seul dyno..."

# Copier le JSON et le script Ruby dans un seul dyno, puis exécuter
cat tmp/all_data.json | heroku run "bash -c 'cat > /tmp/all_data.json && cat > import_from_file.rb'" -a $APP_NAME < import_from_file.rb

echo "✅ Fichiers copiés. Exécution de l'import..."

# Exécuter le script d'import
heroku run "rails runner import_from_file.rb" -a $APP_NAME

echo ""
echo "🎉 Import terminé !"

