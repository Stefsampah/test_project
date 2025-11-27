#!/bin/bash
# Script pour uploader les fichiers JSON encodés en base64 et exécuter l'import sur Heroku dans un seul dyno

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des données sur Heroku dans un seul dyno..."

# Créer un script bash qui décode les fichiers base64 et exécute l'import
{
  echo "set -e"
  echo "mkdir -p tmp"
  echo "echo '📤 Décodage des fichiers JSON...'"
  echo ""
  echo "# Décoder games"
  echo "base64 -d > tmp/games_export_unique.json <<'GAMES_B64'"
  base64 -i tmp/games_export_unique.json
  echo "GAMES_B64"
  echo ""
  echo "# Décoder swipes"
  echo "base64 -d > tmp/swipes_export_unique.json <<'SWIPES_B64'"
  base64 -i tmp/swipes_export_unique.json
  echo "SWIPES_B64"
  echo ""
  echo "# Décoder scores"
  echo "base64 -d > tmp/scores_export_unique.json <<'SCORES_B64'"
  base64 -i tmp/scores_export_unique.json
  echo "SCORES_B64"
  echo ""
  echo "# Décoder badges"
  echo "base64 -d > tmp/user_badges_export_unique.json <<'BADGES_B64'"
  base64 -i tmp/user_badges_export_unique.json
  echo "BADGES_B64"
  echo ""
  echo "# Décoder users"
  echo "base64 -d > tmp/users_export.json <<'USERS_B64'"
  base64 -i tmp/users_export.json
  echo "USERS_B64"
  echo ""
  if [ -f "tmp/rewards_export.json" ]; then
    echo "# Décoder rewards"
    echo "base64 -d > tmp/rewards_export.json <<'REWARDS_B64'"
    base64 -i tmp/rewards_export.json
    echo "REWARDS_B64"
    echo ""
  fi
  if [ -f "tmp/user_playlist_unlocks_export.json" ]; then
    echo "# Décoder unlocks"
    echo "base64 -d > tmp/user_playlist_unlocks_export.json <<'UNLOCKS_B64'"
    base64 -i tmp/user_playlist_unlocks_export.json
    echo "UNLOCKS_B64"
    echo ""
  fi
  echo "# Décoder script Ruby"
  echo "base64 -d > import_complete.rb <<'SCRIPT_B64'"
  base64 -i import_complete.rb
  echo "SCRIPT_B64"
  echo ""
  echo "echo '🔄 Exécution de l'\''import...'"
  echo "rails runner import_complete.rb"
} | heroku run bash -a $APP_NAME

echo ""
echo "✅ Import terminé !"

