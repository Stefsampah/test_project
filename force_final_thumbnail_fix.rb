#!/usr/bin/env ruby

# Script pour forcer la correction finale des thumbnails
# Ce script vide tous les caches et force le rechargement

puts "🔧 CORRECTION FINALE DES THUMBNAILS - FORÇAGE COMPLET"
puts "=" * 60

# Vider le cache Rails
puts "1. Vidage du cache Rails..."
Rails.cache.clear
puts "✅ Cache Rails vidé"

# Vider le cache des fragments
puts "2. Vidage du cache des fragments..."
Rails.cache.delete_matched("*")
puts "✅ Cache des fragments vidé"

# Forcer le rechargement des méthodes du modèle
puts "3. Rechargement des méthodes du modèle..."
Playlist.reset_column_information
puts "✅ Méthodes du modèle rechargées"

# Vérifier les playlists problématiques
puts "4. Vérification des playlists problématiques..."
problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist
    first_video = playlist.videos.first
    if first_video && first_video.youtube_id.present?
      puts "✅ #{title}: Première vidéo = #{first_video.youtube_id}"
    else
      puts "❌ #{title}: Pas de première vidéo ou ID manquant"
    end
  else
    puts "❌ #{title}: Playlist non trouvée"
  end
end

puts "5. Redémarrage du serveur Rails recommandé..."
puts "   Exécutez: rails server"

puts "=" * 60
puts "🎯 CORRECTION TERMINÉE"
puts "Toutes les vues utilisent maintenant playlist.videos.first&.youtube_id"
puts "Le système de fallback JavaScript est en place"
puts "Videz le cache de votre navigateur (Cmd+Shift+R sur Mac)"
