#!/bin/bash
# Script pour uploader et importer les avatars sur Heroku

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des avatars sur Heroku..."

# Créer un script bash qui fait tout dans un seul dyno
{
  echo "set -e"
  echo "mkdir -p tmp"
  echo ""
  echo "echo '📤 Décodage du fichier avatars...'"
  echo "base64 -d > tmp/avatars_export.json <<'AVATARS_B64'"
  base64 -i tmp/avatars_export.json
  echo "AVATARS_B64"
  echo ""
  echo "cat > import_avatars_heroku.rb <<'SCRIPT_B64'"
  cat import_avatars_heroku.rb
  echo "SCRIPT_B64"
  echo ""
  echo "echo '🔄 Exécution de l\\'import des avatars...'"
  echo "rails runner import_avatars_heroku.rb"
} | heroku run bash -a $APP_NAME

echo "✅ Import terminé !"

