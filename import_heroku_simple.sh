#!/bin/bash
# Script simple pour uploader les fichiers JSON et exécuter l'import sur Heroku

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des données sur Heroku..."

# Upload des fichiers JSON un par un
echo "📤 Upload des fichiers JSON..."
cat tmp/games_export_unique.json | heroku run "mkdir -p tmp && cat > tmp/games_export_unique.json" -a $APP_NAME
cat tmp/swipes_export_unique.json | heroku run "cat > tmp/swipes_export_unique.json" -a $APP_NAME
cat tmp/scores_export_unique.json | heroku run "cat > tmp/scores_export_unique.json" -a $APP_NAME
cat tmp/user_badges_export_unique.json | heroku run "cat > tmp/user_badges_export_unique.json" -a $APP_NAME
cat tmp/users_export.json | heroku run "cat > tmp/users_export.json" -a $APP_NAME

# Upload du script d'import
echo "📤 Upload du script d'import..."
cat import_complete.rb | heroku run "cat > import_complete.rb" -a $APP_NAME

# Exécuter l'import dans un nouveau dyno (les fichiers sont déjà uploadés dans tmp/)
echo "🔄 Exécution de l'import..."
heroku run "rails runner import_complete.rb" -a $APP_NAME

echo "✅ Import terminé !"

