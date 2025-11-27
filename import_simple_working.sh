#!/bin/bash
# Script simple et fonctionnel pour importer les données sur Heroku
# Upload les fichiers un par un, puis exécute le script dans le même dyno

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku..."

# Upload et exécution dans un seul dyno bash
heroku run bash -a $APP_NAME <<'ENDOFSCRIPT'
set -e
mkdir -p tmp

echo "📤 Upload des fichiers JSON..."

# Upload games
cat > tmp/games_export_unique.json <<'GAMES_END'
ENDOFSCRIPT

cat tmp/games_export_unique.json >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
GAMES_END

# Upload swipes
cat > tmp/swipes_export_unique.json <<'SWIPES_END'
ENDOFSCRIPT

cat tmp/swipes_export_unique.json >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
SWIPES_END

# Upload scores
cat > tmp/scores_export_unique.json <<'SCORES_END'
ENDOFSCRIPT

cat tmp/scores_export_unique.json >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
SCORES_END

# Upload badges
cat > tmp/user_badges_export_unique.json <<'BADGES_END'
ENDOFSCRIPT

cat tmp/user_badges_export_unique.json >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
BADGES_END

# Upload users
cat > tmp/users_export.json <<'USERS_END'
ENDOFSCRIPT

cat tmp/users_export.json >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
USERS_END

# Upload script Ruby
cat > import_complete.rb <<'SCRIPT_END'
ENDOFSCRIPT

cat import_complete.rb >> /tmp/heroku_import_temp.sh
cat >> /tmp/heroku_import_temp.sh <<'ENDOFSCRIPT'
SCRIPT_END

echo "🔄 Exécution de l'import..."
rails runner import_complete.rb
ENDOFSCRIPT

cat /tmp/heroku_import_temp.sh | heroku run bash -a $APP_NAME
rm -f /tmp/heroku_import_temp.sh

echo "✅ Import terminé !"

