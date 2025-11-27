#!/bin/bash
# Script pour uploader et importer les avatars sur Heroku (version améliorée)

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des avatars sur Heroku..."

# Upload du fichier JSON directement
cat tmp/avatars_export.json | heroku run "mkdir -p tmp && cat > tmp/avatars_export.json" -a $APP_NAME

# Upload et exécution du script d'import dans le même dyno
cat import_avatars_heroku.rb | heroku run "cat > import_avatars_heroku.rb && rails runner import_avatars_heroku.rb" -a $APP_NAME

echo "✅ Import terminé !"

