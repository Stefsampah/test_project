#!/bin/bash
# Script pour uploader tous les fichiers JSON et exécuter l'import sur Heroku dans un seul dyno

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des données sur Heroku dans un seul dyno..."

# Exécuter tout dans un seul dyno bash
{
  echo "mkdir -p tmp"
  echo "cat > tmp/games_export_unique.json <<'GAMES_EOF'"
  cat tmp/games_export_unique.json
  echo "GAMES_EOF"
  echo "cat > tmp/swipes_export_unique.json <<'SWIPES_EOF'"
  cat tmp/swipes_export_unique.json
  echo "SWIPES_EOF"
  echo "cat > tmp/scores_export_unique.json <<'SCORES_EOF'"
  cat tmp/scores_export_unique.json
  echo "SCORES_EOF"
  echo "cat > tmp/user_badges_export_unique.json <<'BADGES_EOF'"
  cat tmp/user_badges_export_unique.json
  echo "BADGES_EOF"
  echo "cat > tmp/users_export.json <<'USERS_EOF'"
  cat tmp/users_export.json
  echo "USERS_EOF"
  echo "cat > import_complete.rb <<'SCRIPT_EOF'"
  cat import_complete.rb
  echo "SCRIPT_EOF"
  echo "rails runner import_complete.rb"
} | heroku run bash -a $APP_NAME

echo "✅ Import terminé !"

