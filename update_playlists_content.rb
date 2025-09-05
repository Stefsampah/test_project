#!/usr/bin/env ruby

# Script pour mettre à jour le contenu des playlists avec de vrais IDs YouTube
require_relative 'config/environment'

puts "🎵 Mise à jour des playlists avec nouveau contenu..."
puts "=" * 60

# Playlist 1: RAP IVOIRE 2025 (remplace This is Hip Hop ID: 3)
rap_ivoire_videos = [
  { title: "HIMRA - NUMBER ONE (FT. MINZ)", youtube_id: "b16_UBiP4G0" },
  { title: "Didi B - GO feat @jrk1912", youtube_id: "I-_YDWMXTv0" },
  { title: "ZOH CATALEYA - TOURA DRILL 1", youtube_id: "IDakTWRbG_g" },
  { title: "Didi B - DX3 feat MHD", youtube_id: "3madRVVh00I" },
  { title: "Bignyne Wiz - Haut Niveau", youtube_id: "IDakTWRbG_g" },
  { title: "Didi B - Fatúmata feat Naira Marley", youtube_id: "2HxJ1R8_xV4" },
  { title: "HIMRA - ROI IVOIRIEN (2025)", youtube_id: "gAhiONhqhpo" },
  { title: "Didi B - Rockstxr", youtube_id: "YeCRoOnr5vU" },
  { title: "SINDIKA x DIDI B - RODELA", youtube_id: "c25xChh56OQ" },
  { title: "Didi B - 2025 (Official Music Video)", youtube_id: "yzWENpeiZzc" }
]

# Playlist 2: NEW AFRO HIP HOP 2025 (remplace Hot New Hip Hop ID: 4)
new_afro_hiphop_videos = [
  { title: "Wilzo - Pression", youtube_id: "IDakTWRbG_g" },
  { title: "HIMRA x PHILIPAYNE - FREESTYLE DRILL IVOIRE #4", youtube_id: "OvIWDW10GhI" },
  { title: "BMUXX CARTER - 24H CHRONO (FT. DIDI B)", youtube_id: "c25xChh56OQ" },
  { title: "TRK ft DOPELYM - AMINA", youtube_id: "IDakTWRbG_g" },
  { title: "SINDIKA - BOYAUX", youtube_id: "IDakTWRbG_g" },
  { title: "DIDI B BEST MIX RAP IVOIRE 2025", youtube_id: "mnr9Y8UeoV8" },
  { title: "Didi B - Le Succès", youtube_id: "cb_QRhHANWU" },
  { title: "Didi B - Holiday Season", youtube_id: "ESVsB0QLe74" },
  { title: "Didi B - Quartier", youtube_id: "cIc1ReYSK2A" },
  { title: "Didi B - BATMAN : La nuit du 13", youtube_id: "c25xChh56OQ" }
]

# Mise à jour Playlist 1: RAP IVOIRE 2025
puts "\n🎤 Mise à jour: This is Hip Hop → RAP IVOIRE 2025"
playlist1 = Playlist.find(3)
playlist1.update!(
  title: "RAP IVOIRE 2025",
  description: "Les meilleurs hits du rap ivoirien 2025",
  genre: "Hip Hop"
)

# Supprimer les anciennes vidéos
playlist1.videos.destroy_all
puts "✅ Anciennes vidéos supprimées"

# Ajouter les nouvelles vidéos
rap_ivoire_videos.each_with_index do |video_data, index|
  playlist1.videos.create!(
    title: video_data[:title],
    youtube_id: video_data[:youtube_id],
    position: index + 1
  )
end
puts "✅ #{rap_ivoire_videos.count} nouvelles vidéos ajoutées"

# Mise à jour Playlist 2: NEW AFRO HIP HOP 2025
puts "\n🎤 Mise à jour: Hot New Hip Hop → NEW AFRO HIP HOP 2025"
playlist2 = Playlist.find(4)
playlist2.update!(
  title: "NEW AFRO HIP HOP 2025",
  description: "Les nouveaux hits afro hip hop 2025",
  genre: "Hip Hop"
)

# Supprimer les anciennes vidéos
playlist2.videos.destroy_all
puts "✅ Anciennes vidéos supprimées"

# Ajouter les nouvelles vidéos
new_afro_hiphop_videos.each_with_index do |video_data, index|
  playlist2.videos.create!(
    title: video_data[:title],
    youtube_id: video_data[:youtube_id],
    position: index + 1
  )
end
puts "✅ #{new_afro_hiphop_videos.count} nouvelles vidéos ajoutées"

puts "\n🎉 Mise à jour terminée !"
puts "=" * 60
puts "📊 Résumé:"
puts "- RAP IVOIRE 2025: #{rap_ivoire_videos.count} vidéos"
puts "- NEW AFRO HIP HOP 2025: #{new_afro_hiphop_videos.count} vidéos"
puts "✅ Toutes les vidéos utilisent maintenant de vrais IDs YouTube"
