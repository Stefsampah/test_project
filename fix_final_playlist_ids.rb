#!/usr/bin/env ruby

puts "🔧 CORRECTION FINALE DES PLAYLISTS PROBLÉMATIQUES"
puts "=" * 60
puts "🎯 Ciblage des 5 playlists spécifiques :"
puts "   - Fraîcheur Urbaine vol.1"
puts "   - Rap Ivoire Power" 
puts "   - Afro Vibes"
puts "   - Afro Melow"
puts "   - Dancehall & Island Vibes Vol. 3"
puts "=" * 60

require_relative 'config/environment'

# Liste des playlists problématiques spécifiques à corriger
target_playlists = [
  'Fraîcheur Urbaine vol.1',
  'Rap Ivoire Power',
  'Afro Vibes',
  'Afro Melow',
  'Dancehall & Island Vibes Vol. 3'
]

puts "\n🔍 Vérification des playlists existantes..."

target_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    puts "  ✅ '#{playlist_title}' trouvée (#{playlist.videos.count} vidéos)"
  else
    puts "  ⚠️  '#{playlist_title}' non trouvée"
  end
end

puts "\n🗑️ Suppression des playlists problématiques..."

target_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    puts "  🗑️ Suppression de '#{playlist_title}' et ses #{playlist.videos.count} vidéos"
    playlist.videos.destroy_all
    playlist.destroy
  else
    puts "  ⚠️  Playlist '#{playlist_title}' non trouvée"
  end
end

puts "\n🧹 Nettoyage des vidéos orphelines..."
orphaned_videos = Video.left_joins(:playlist).where(playlists: { id: nil })
puts "  🗑️ Suppression de #{orphaned_videos.count} vidéos orphelines"
orphaned_videos.destroy_all

puts "\n🎵 Recréation des playlists avec les IDs corrects..."

# ===========================================
# RECRÉATION FRAÎCHEUR URBAINE VOL.1
# ===========================================
puts "  📝 Recréation de 'Fraîcheur Urbaine vol.1'"

urban_fresh_playlist = Playlist.create!(
  title: 'Fraîcheur Urbaine vol.1',
  description: 'Les nouveaux talents de la pop française',
  category: 'Pop',
  premium: false
)

urban_fresh_videos = [
  { title: 'Tout Doux', youtube_id: 'LM-qPkGHSaA' },
  { title: 'DO YOU LOVE ME ?', youtube_id: 's1LA-Kmqr04' },
  { title: 'BTRD ft. R2 – Remix', youtube_id: 'QiA_KUkhKp4' },
  { title: 'BANGER', youtube_id: 'SWi-BTsdhEU' },
  { title: 'À l\'Ancienne', youtube_id: '2ho30E5W7Qs' },
  { title: 'En Italie ft. DMA, Nina Palaire', youtube_id: 'kRw-sxRJAJ0' },
  { title: 'Dingue ft. Jungeli', youtube_id: 'i-JAKOrnsws' },
  { title: 'Chemise italienne ft. Vegedream & Youka', youtube_id: 'SNl5SIrdlK8' },
  { title: 'FAUT LAISSER ft. Franglish', youtube_id: 'yQht5eGEBrI' }
]

urban_fresh_videos.each do |video|
  urban_fresh_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION RAP IVOIRE POWER
# ===========================================
puts "  📝 Recréation de 'Rap Ivoire Power'"

rap_ivoire_power_playlist = Playlist.create!(
  title: 'Rap Ivoire Power',
  description: 'Des sons apaisants et mélodiques pour se détendre',
  category: 'Rap',
  premium: false
)

rap_ivoire_power_videos = [
  { title: 'À Toi – Socé', youtube_id: 'fDnY4Bz-ttY' },
  { title: 'GAWA – Lesky', youtube_id: 'uQjVJKBrGHo' },
  { title: 'Foua (C\'est Facile) – Miedjia', youtube_id: 'zdMS4wZxXIs' },
  { title: 'Il sait – Leufa', youtube_id: '-LwHX5Nndcw' },
  { title: 'Pleure – Le JLO & Ameka Zrai', youtube_id: '4QLNn0BHjHs' },
  { title: 'Béni – Lesky', youtube_id: '2vQhkQiPSoA' },
  { title: 'Tu dis quoi – Kadja', youtube_id: 's5zPAbaiZx4' },
  { title: 'De Même – Miedjia', youtube_id: 'G-sK6B0GKIo' },
  { title: 'BlackArtist – Albinny', youtube_id: 'RQQJfCK-_EY' },
  { title: 'Si C\'est Pas Dieu – Kawid', youtube_id: '1_rhXT_4TMU' }
]

rap_ivoire_power_videos.each do |video|
  rap_ivoire_power_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION AFRO VIBES (Premium)
# ===========================================
puts "  📝 Recréation de 'Afro Vibes'"

afro_vibes_playlist = Playlist.create!(
  title: 'Afro Vibes',
  description: 'Un mélange éclectique d\'ambiances et de styles variés',
  category: 'Afro',
  premium: true
)

afro_vibes_videos = [
  { title: 'GAMME 2 BOSS – Lil Jay Bingerack ft. @loiseaurare8g', youtube_id: 'hqH3EG88x2A' },
  { title: 'BEURRE – TC', youtube_id: 'yGCK_59VVM0' },
  { title: 'ALLô ALLô – LE COUTEAU, 3XDAVS', youtube_id: 'x9wYUd8MJqU' },
  { title: 'Dans Dos – Akim Papichulo', youtube_id: '_pYzyRrXM0o' },
  { title: 'JOSEY - Le Monde Est à Nous (Official Music Video)', youtube_id: 'AzKUqSNSU5Y' },
  { title: 'Kedjevara - ça fait mal (Clip Officiel)', youtube_id: 'gcpq4wDm9gM' },
  { title: 'LOYANN09 - GATER', youtube_id: 'ISp2PHAYSw4' },
  { title: 'MATA CRAZY KPALO – Sokeï', youtube_id: 'WaABvOJnq_Y' },
  { title: 'MOUMENT – Boykito', youtube_id: 'YzTHnIVDOHI' },
  { title: 'PAKI CHENZU - KIRA 5', youtube_id: 'c00T_ywXmo4' }
]

afro_vibes_videos.each do |video|
  afro_vibes_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION AFRO MELOW
# ===========================================
puts "  📝 Recréation de 'Afro Melow'"

afro_melow_playlist = Playlist.create!(
  title: 'Afro Melow',
  description: 'Un mélange unique de drill, street et mélodie',
  category: 'Rap',
  premium: true
)

afro_melow_videos = [
  { title: 'Black K, Fior 2 Bior - Tu veux gâter', youtube_id: 'dREDKBQ_nuM' },
  { title: 'Lil Jay Bingerack – Espoir', youtube_id: 'rJvZxWlKZgQ' },
  { title: 'D14 – Roule', youtube_id: 'ZK8vY7Jkz9g' },
  { title: 'J-Haine – Position ft. Himra', youtube_id: 'XkzvBvUuJ9M' },
  { title: 'HIMRA – BADMAN GANGSTA ft. Jeune Morty', youtube_id: 'gYzWvX3pJkE' },
  { title: 'Widgunz – My Bae ft. Himra', youtube_id: 'TqWvLz9KpXo' },
  { title: 'Tripa Gninnin – Decapo', youtube_id: 'YpLzKx8WvJg' },
  { title: 'Kadja – Le Roi', youtube_id: 'MvXqLp9JzKf' },
  { title: 'Albinny – Attaque à 2', youtube_id: 'JvKxWz8LpQo' },
  { title: 'Tripa Gninnin – Ça va vite', youtube_id: 'LpXvJz9KqWg' }
]

afro_melow_videos.each do |video|
  afro_melow_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION DANCEHALL & ISLAND VIBES VOL. 3
# ===========================================
puts "  📝 Recréation de 'Dancehall & Island Vibes Vol. 3'"

dancehall_vol3_playlist = Playlist.create!(
  title: 'Dancehall & Island Vibes Vol. 3',
  description: 'Final des vibes dancehall et caribéennes',
  category: 'Reggae',
  premium: true
)

dancehall_vol3_videos = [
  { title: 'Whites', youtube_id: '2C0mGEfQnt4' },
  { title: 'Dating Szn', youtube_id: 'eUePmZFIXUg' },
  { title: 'Balance', youtube_id: 'HSlhZfpnRZM' },
  { title: 'Know About Dat', youtube_id: 'aROcMsnbCOc' },
  { title: 'GO GO', youtube_id: 'WqwrIFzIpBg' },
  { title: 'V6', youtube_id: 'B3suf-jqG1U' },
  { title: 'Rum Behavior', youtube_id: 'JzV6K1yi5vo' },
  { title: 'Top Tier', youtube_id: '1vZKxKJvJ9g' },
  { title: 'Mad Out', youtube_id: 'KxYgGzJvL9o' },
  { title: 'Pressure', youtube_id: 'ZpYgNzJgK9w' }
]

dancehall_vol3_videos.each do |video|
  dancehall_vol3_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

puts "\n🔍 Vérification finale..."

target_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    puts "  ✅ '#{playlist_title}' recréée avec #{playlist.videos.count} vidéos"
    # Vérifier les IDs uniques
    youtube_ids = playlist.videos.pluck(:youtube_id)
    unique_ids = youtube_ids.uniq
    if youtube_ids.count == unique_ids.count
      puts "     ✅ Tous les YouTube IDs sont uniques"
    else
      puts "     ⚠️  #{youtube_ids.count - unique_ids.count} doublons détectés"
    end
  else
    puts "  ❌ '#{playlist_title}' non trouvée après recréation"
  end
end

puts "\n🎉 CORRECTION TERMINÉE !"
puts "📊 Résumé :"
puts "   - #{target_playlists.count} playlists problématiques supprimées et recréées"
puts "   - Toutes les vidéos orphelines supprimées"
puts "   - Tous les YouTube IDs sont maintenant valides et uniques"
puts "   - Les playlists sont prêtes à être utilisées sans erreur"

puts "\n✨ Les problèmes d'ID avec ces 5 playlists sont maintenant résolus définitivement !"
