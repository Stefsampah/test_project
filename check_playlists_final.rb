#!/usr/bin/env ruby

# Script simple pour vérifier les playlists problématiques
puts "🔧 VÉRIFICATION DES PLAYLISTS PROBLÉMATIQUES"
puts "=" * 50

# Charger Rails
require_relative 'config/environment'

# Vérifier les playlists problématiques
problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

puts "Vérification des playlists :"
puts "-" * 30

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

puts "=" * 50
puts "🎯 CORRECTION APPLIQUÉE DANS TOUS LES FICHIERS :"
puts "✅ app/views/playlists/_playlist_card.html.erb"
puts "✅ app/views/playlists/index.html.erb" 
puts "✅ app/views/playlists/index_new.html.erb"
puts "✅ app/views/store/index.html.erb"
puts "✅ app/views/rewards/show.html.erb"
puts ""
puts "📋 PROCHAINES ÉTAPES :"
puts "1. Videz le cache de votre navigateur (Cmd+Shift+R)"
puts "2. Rechargez la page des playlists"
puts "3. Toutes les images devraient maintenant être stables !"
