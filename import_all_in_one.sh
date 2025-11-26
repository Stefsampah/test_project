#!/bin/bash
# Script pour copier tous les fichiers et exécuter l'import dans un seul dyno Heroku

APP_NAME="tubenplay-app"

echo "🚀 Copie de tous les fichiers et exécution de l'import dans un seul dyno..."

# Encoder tous les fichiers en base64 et les passer à une commande bash unique
heroku run "bash -c \"
mkdir -p tmp
cat > tmp/games_export_unique.json << 'GAMES_EOF'
$(cat tmp/games_export_unique.json)
GAMES_EOF
cat > tmp/swipes_export_unique.json << 'SWIPES_EOF'
$(cat tmp/swipes_export_unique.json)
SWIPES_EOF
cat > tmp/scores_export_unique.json << 'SCORES_EOF'
$(cat tmp/scores_export_unique.json)
SCORES_EOF
cat > tmp/user_badges_export_unique.json << 'BADGES_EOF'
$(cat tmp/user_badges_export_unique.json)
BADGES_EOF
cat > tmp/users_export.json << 'USERS_EOF'
$(cat tmp/users_export.json)
USERS_EOF
cat > import_to_heroku_simple.rb << 'SCRIPT_EOF'
$(cat import_to_heroku_simple.rb)
SCRIPT_EOF
rails runner import_to_heroku_simple.rb
\"" -a $APP_NAME

echo ""
echo "🎉 Import terminé !"

