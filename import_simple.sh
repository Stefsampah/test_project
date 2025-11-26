#!/bin/bash
# Script simple pour importer les données sur Heroku
# Copie le JSON et le script dans un seul dyno, puis exécute

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku..."

# Créer un script bash qui copie les deux fichiers et exécute l'import
# On utilise un heredoc pour passer le script bash via stdin
heroku run "bash" -a $APP_NAME << 'HEROKU_SCRIPT'
# Copier le JSON depuis stdin
cat > /tmp/all_data.json
HEROKU_SCRIPT
< tmp/all_data.json

# Maintenant copier le script Ruby
cat import_from_file.rb | heroku run "cat > import_from_file.rb" -a $APP_NAME

# Exécuter le script dans le même dyno... mais chaque heroku run crée un nouveau dyno
# Donc on doit copier les deux fichiers et exécuter dans UNE SEULE commande
echo "✅ Fichiers copiés. Exécution de l'import..."
heroku run "rails runner import_from_file.rb" -a $APP_NAME

echo ""
echo "🎉 Import terminé !"

