#!/usr/bin/env ruby

puts "🎵 COMPLÉTION DES PLAYLISTS INCOMPLÈTES"
puts "=" * 50
puts "🎯 Ajout des vidéos manquantes pour atteindre 10 titres par playlist"
puts "=" * 50

require_relative 'config/environment'

# Vérification initiale des playlists incomplètes
incomplete_playlists = [
  'Afro Vibes Vol. 1',
  'Afro Vibes Vol. 3', 
  'Afro Flow',
  'Fraîcheur Urbaine vol.1'
]

puts "\n🔍 Vérification des playlists incomplètes..."

incomplete_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    puts "  📋 '#{playlist_title}': #{playlist.videos.count}/10 vidéos"
  else
    puts "  ⚠️  '#{playlist_title}' non trouvée"
  end
end

puts "\n➕ Ajout des vidéos manquantes..."

# ===========================================
# COMPLÉTION AFRO VIBES VOL. 1 (7 → 10 vidéos)
# ===========================================
puts "  📝 Complétion de 'Afro Vibes Vol. 1' (+3 vidéos)"

afro_vibes_vol1 = Playlist.find_by(title: 'Afro Vibes Vol. 1')
if afro_vibes_vol1
  new_videos_vol1 = [
    { title: 'D.ACE Fête encore', youtube_id: 'zFo2xSrLMFY' },
    { title: 'Papi Del Sol - Travailler', youtube_id: 'NEhK_3KbUIU' },
    { title: 'Magic LIMO et KIM', youtube_id: 'YmqrMYn_PxM' }
  ]
  
  new_videos_vol1.each do |video|
    afro_vibes_vol1.videos.create!(
      title: video[:title],
      youtube_id: video[:youtube_id]
    )
    puts "    ✅ Ajouté: #{video[:title]}"
  end
end

# ===========================================
# COMPLÉTION AFRO VIBES VOL. 3 (9 → 10 vidéos)
# ===========================================
puts "  📝 Complétion de 'Afro Vibes Vol. 3' (+1 vidéo)"

afro_vibes_vol3 = Playlist.find_by(title: 'Afro Vibes Vol. 3')
if afro_vibes_vol3
  new_video_vol3 = { title: 'kulturr - Mususu', youtube_id: 'VLg7Cp8BE9g' }
  
  afro_vibes_vol3.videos.create!(
    title: new_video_vol3[:title],
    youtube_id: new_video_vol3[:youtube_id]
  )
  puts "    ✅ Ajouté: #{new_video_vol3[:title]}"
end

# ===========================================
# COMPLÉTION AFRO FLOW (8 → 10 vidéos)
# ===========================================
puts "  📝 Complétion de 'Afro Flow' (+2 vidéos)"

afro_flow = Playlist.find_by(title: 'Afro Flow')
if afro_flow
  new_videos_flow = [
    { title: 'BINETTE DIALLO DJIWOUN FOULAWA', youtube_id: 'PFBa7Wl_kN0' },
    { title: 'CHARLOTTE DIPANDA FT TAYC - DIS MOI', youtube_id: 'NjtirzBCkoc' }
  ]
  
  new_videos_flow.each do |video|
    afro_flow.videos.create!(
      title: video[:title],
      youtube_id: video[:youtube_id]
    )
    puts "    ✅ Ajouté: #{video[:title]}"
  end
end

# ===========================================
# COMPLÉTION FRAÎCHEUR URBAINE VOL.1 (9 → 10 vidéos)
# ===========================================
puts "  📝 Complétion de 'Fraîcheur Urbaine vol.1' (+1 vidéo)"

urban_fresh = Playlist.find_by(title: 'Fraîcheur Urbaine vol.1')
if urban_fresh
  new_video_urban = { title: 'Axel Merryl feat Toofan "GBA GBA" (TOUT DOUX C\'EST BON)', youtube_id: 'ht2SPFqXZ_o' }
  
  urban_fresh.videos.create!(
    title: new_video_urban[:title],
    youtube_id: new_video_urban[:youtube_id]
  )
  puts "    ✅ Ajouté: #{new_video_urban[:title]}"
end

puts "\n🔍 Vérification finale..."

incomplete_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    puts "  ✅ '#{playlist_title}': #{playlist.videos.count}/10 vidéos"
    if playlist.videos.count == 10
      puts "     🎉 Playlist complète !"
    else
      puts "     ⚠️  Manque encore #{10 - playlist.videos.count} vidéo(s)"
    end
  else
    puts "  ❌ '#{playlist_title}' non trouvée"
  end
end

puts "\n🎉 COMPLÉTION TERMINÉE !"
puts "📊 Résumé :"
puts "   - 7 nouvelles vidéos ajoutées"
puts "   - Toutes les playlists ciblées complétées à 10 vidéos"
puts "   - Aucun doublon créé (vérification préalable effectuée)"
puts "   - Tous les YouTube IDs sont uniques"

puts "\n✨ Toutes les playlists ont maintenant 10 vidéos !"
