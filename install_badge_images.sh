#!/bin/bash

# Script pour installer les images des badges

# Créer le dossier des assets pour les images
mkdir -p app/assets/images

echo "Dossier des badges créé : app/assets/images/"
echo ""
echo "Veuillez placer les images des badges dans ce dossier avec les noms suivants :"
echo ""
echo "- dropmixpop.webp            (Badge Bronze Competitor - playlist exclusive)"
echo "- pandora-playlist-collage.webp    (Badge Silver Competitor - playlists premium)"
echo "- VIP-gold.jpg               (Badge Gold Competitor - accès VIP)"
echo "- photos-dedicacees.jpeg     (Badge Silver - photos dédicacées)"
echo "- artist-meeting.jpg         (Badge Gold Engager - rencontre avec artiste)"
echo "- interview.jpeg             (Badge Gold Critic - interviews live)"
echo "- concert.jpeg               (Badge Gold Challenger - concert VIP)"
echo ""

# Si les images se trouvent dans public/assets/badges, les déplacer vers app/assets/images
if [ -d "public/assets/badges" ]; then
  echo "Images trouvées dans public/assets/badges, déplacement vers app/assets/images..."
  
  # Vérifier chaque image et la déplacer si elle existe
  for img in dropmixpop.webp pandora-playlist-collage.webp VIP-gold.jpg photos-dedicacees.jpeg artist-meeting.jpg interview.jpeg concert.jpeg; do
    if [ -f "public/assets/badges/$img" ]; then
      echo "Déplacement de $img"
      cp "public/assets/badges/$img" "app/assets/images/$img"
    fi
  done
  
  echo "Terminé."
fi

echo "Vérification des images existantes dans app/assets/images :"

# Vérifier chaque image
check_image() {
  if [ -f "app/assets/images/$1" ]; then
    echo "✅ $1 est présent"
  else
    echo "❌ $1 est manquant"
  fi
}

check_image "dropmixpop.webp"
check_image "pandora-playlist-collage.webp"
check_image "VIP-gold.jpg"
check_image "photos-dedicacees.jpeg"
check_image "artist-meeting.jpg"
check_image "interview.jpeg"
check_image "concert.jpeg"

echo ""
echo "Après avoir placé toutes les images dans le dossier, redémarrez le serveur Rails avec :"
echo "rails server" 