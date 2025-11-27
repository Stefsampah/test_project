#!/bin/bash
# Script pour uploader tous les fichiers JSON et exécuter l'import sur Heroku dans un seul dyno

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des données sur Heroku dans un seul dyno..."

# Créer un script bash qui fait tout dans un seul dyno
{
  echo "mkdir -p tmp"
  echo ""
  echo "echo '📤 Upload des fichiers JSON...'"
  echo ""
  echo "cat > tmp/games_export_unique.json"
  cat tmp/games_export_unique.json
  echo ""
  echo "cat > tmp/swipes_export_unique.json"
  cat tmp/swipes_export_unique.json
  echo ""
  echo "cat > tmp/scores_export_unique.json"
  cat tmp/scores_export_unique.json
  echo ""
  echo "cat > tmp/user_badges_export_unique.json"
  cat tmp/user_badges_export_unique.json
  echo ""
  echo "cat > tmp/users_export.json"
  cat tmp/users_export.json
  echo ""
  echo "cat > import_complete.rb"
  cat import_complete.rb
  echo ""
  echo "echo '🔄 Exécution de l'\''import...'"
  echo "rails runner import_complete.rb"
} | heroku run bash -a $APP_NAME

echo "✅ Import terminé !"

