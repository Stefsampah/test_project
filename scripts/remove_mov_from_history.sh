#!/bin/sh
# Supprime tous les .mov du dossier about (pour filter-branch --tree-filter).
# À copier dans /tmp/rmmov.sh puis : chmod +x /tmp/rmmov.sh
if [ -d "app/assets/images/about" ]; then
  find app/assets/images/about -type f \( -name "*.mov" -o -name "*tubenplay*" \) -delete 2>/dev/null || true
  git add -u 2>/dev/null || true
fi
