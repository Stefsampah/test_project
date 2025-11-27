#!/bin/bash
# Solution simple et directe : upload les fichiers puis exécute le script dans le même dyno

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku..."

# Créer un script temporaire qui fait tout
TEMP_SCRIPT=$(mktemp)

# Construire le script bash
cat > "$TEMP_SCRIPT" <<'SCRIPT_START'
set -e
mkdir -p tmp
echo "📤 Upload des fichiers JSON..."

# Utiliser des délimiteurs uniques basés sur un timestamp
DELIM_GAMES="GAMES_$(date +%s)_$$"
DELIM_SWIPES="SWIPES_$(date +%s)_$$"
DELIM_SCORES="SCORES_$(date +%s)_$$"
DELIM_BADGES="BADGES_$(date +%s)_$$"
DELIM_USERS="USERS_$(date +%s)_$$"
DELIM_SCRIPT="SCRIPT_$(date +%s)_$$"

# Upload games
cat > tmp/games_export_unique.json <<EOF_GAMES
SCRIPT_START

cat tmp/games_export_unique.json >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_MID1'
EOF_GAMES

# Upload swipes
cat > tmp/swipes_export_unique.json <<EOF_SWIPES
SCRIPT_MID1

cat tmp/swipes_export_unique.json >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_MID2'
EOF_SWIPES

# Upload scores
cat > tmp/scores_export_unique.json <<EOF_SCORES
SCRIPT_MID2

cat tmp/scores_export_unique.json >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_MID3'
EOF_SCORES

# Upload badges
cat > tmp/user_badges_export_unique.json <<EOF_BADGES
SCRIPT_MID3

cat tmp/user_badges_export_unique.json >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_MID4'
EOF_BADGES

# Upload users
cat > tmp/users_export.json <<EOF_USERS
SCRIPT_MID4

cat tmp/users_export.json >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_MID5'
EOF_USERS

# Upload script Ruby
cat > import_complete.rb <<EOF_SCRIPT
SCRIPT_MID5

cat import_complete.rb >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" <<'SCRIPT_END'
EOF_SCRIPT

echo "🔄 Exécution de l'import..."
rails runner import_complete.rb
SCRIPT_END

# Exécuter le script sur Heroku
cat "$TEMP_SCRIPT" | heroku run bash -a $APP_NAME

# Nettoyer
rm -f "$TEMP_SCRIPT"

echo "✅ Import terminé !"

