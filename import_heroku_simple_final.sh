#!/bin/bash
# Solution simple et directe : upload les fichiers puis exécute le script dans le même dyno

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku..."

# Upload les fichiers un par un, puis exécute le script dans le même dyno
heroku run bash -a $APP_NAME <<'SCRIPT_END'
set -e
mkdir -p tmp

echo "📤 Upload des fichiers JSON..."

# Upload games
cat > tmp/games_export_unique.json
SCRIPT_END

cat tmp/games_export_unique.json | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > tmp/games_export_unique.json

# Upload swipes
cat > tmp/swipes_export_unique.json
SCRIPT_END

cat tmp/swipes_export_unique.json | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > tmp/swipes_export_unique.json

# Upload scores
cat > tmp/scores_export_unique.json
SCRIPT_END

cat tmp/scores_export_unique.json | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > tmp/scores_export_unique.json

# Upload badges
cat > tmp/user_badges_export_unique.json
SCRIPT_END

cat tmp/user_badges_export_unique.json | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > tmp/user_badges_export_unique.json

# Upload users
cat > tmp/users_export.json
SCRIPT_END

cat tmp/users_export.json | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > tmp/users_export.json

# Upload script Ruby
cat > import_complete.rb
SCRIPT_END

cat import_complete.rb | heroku run bash -a $APP_NAME <<'SCRIPT_END'
cat > import_complete.rb

echo "🔄 Exécution de l'import..."
rails runner import_complete.rb
SCRIPT_END

echo "✅ Import terminé !"

