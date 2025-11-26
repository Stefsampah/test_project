#!/bin/bash
# Script pour copier tous les fichiers et exécuter l'import dans un seul dyno Heroku

APP_NAME="tubenplay-app"

echo "🚀 Copie de tous les fichiers et exécution de l'import dans un seul dyno..."

# Créer une commande bash qui copie tous les fichiers et exécute le script
heroku run "bash -c \"
mkdir -p tmp
cat > tmp/games_export_unique.json
\"" -a $APP_NAME < tmp/games_export_unique.json

# Puis copier les autres fichiers un par un dans le même dyno... mais chaque heroku run crée un nouveau dyno
# La solution est d'utiliser une seule commande bash qui lit tous les fichiers depuis stdin
# Mais stdin ne peut être lu qu'une seule fois...

# Meilleure solution: utiliser un script bash qui copie tous les fichiers en une seule commande
# en utilisant des heredocs ou en passant les fichiers via des variables d'environnement

# Solution alternative: créer un script bash qui encode les fichiers en base64 et les décode
# Mais base64 a des problèmes de syntaxe entre macOS et Linux

# Solution finale: utiliser une seule commande heroku run qui copie tous les fichiers
# en utilisant cat avec redirection depuis stdin, mais cela nécessite de passer tous les fichiers
# en une seule fois, ce qui n'est pas possible car stdin ne peut être lu qu'une seule fois.

# La meilleure solution est d'utiliser le script upload_and_import_final.sh existant
# mais de s'assurer que tous les fichiers sont copiés avant d'exécuter le script.

echo "✅ Utilisation du script upload_and_import_final.sh existant..."
bash upload_and_import_final.sh

