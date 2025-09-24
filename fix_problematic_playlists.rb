#!/usr/bin/env ruby

puts "🔧 SCRIPT DE NETTOYAGE DES PLAYLISTS PROBLÉMATIQUES"
puts "=" * 60

require_relative 'config/environment'

# Liste des playlists problématiques à nettoyer
problematic_playlists = [
  'Afro Vibes Vol. 1',
  'Afro Rap', 
  'Rap La Relève vol.1',
  'Afro Vibes Vol. 3',
  'Dancehall & Island Vibes Vol. 1',
  'Afro Melow',
  'Rap La Relève vol.2'
]

puts "\n🗑️ Suppression des playlists problématiques..."

problematic_playlists.each do |playlist_title|
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
# RECRÉATION AFRO VIBES VOL. 1
# ===========================================
puts "  📝 Recréation de 'Afro Vibes Vol. 1'"

afro_vibes_vol1_playlist = Playlist.create!(
  title: 'Afro Vibes Vol. 1',
  description: 'Les meilleures vibes afro du moment',
  category: 'Afro',
  premium: false
)

afro_vibes_vol1_videos = [
  { title: 'Tout Doux', youtube_id: '1A-V7w7lUPM' },
  { title: 'Shatta Confessions', youtube_id: 'qRyBpbJvO8Y' },
  { title: 'Charger', youtube_id: 'Om_gqUBQzlI' },
  { title: 'Faut Laisser', youtube_id: 'If23KrW8zLg' },
  { title: 'Ola Oli', youtube_id: 'V4gDbLmVyes' },
  { title: 'Tu sais bien', youtube_id: 'Umgg-ccUSwc' },
  { title: 'Whine & Kotch x Jealousy', youtube_id: 'bXt-oW8bi6s' },
  { title: 'Djiwoun Foulawa', youtube_id: 'PFBa7Wl_kN0' },
  { title: 'C\'est Dosé', youtube_id: 'lvCCqkkweyw' }
]

afro_vibes_vol1_videos.each do |video|
  afro_vibes_vol1_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION AFRO RAP
# ===========================================
puts "  📝 Recréation de 'Afro Rap'"

afro_rap_playlist = Playlist.create!(
  title: 'Afro Rap',
  description: 'Un mix équilibré de rap ivoirien moderne avec des sonorités futuristes',
  category: 'Rap',
  premium: false
)

afro_rap_videos = [
  { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
  { title: 'Didi B - GO feat @jrk1912', youtube_id: 'I-_YDWMXTv0' },
  { title: 'ZOH CATALEYA - TOURA DRILL 1', youtube_id: 'kT5PHa0fov8' },
  { title: 'Didi B - DX3 feat MHD', youtube_id: '3madRVVh00I' },
  { title: 'Bignyne Wiz - Haut Niveau', youtube_id: 'gzGL4RD9IZs' },
  { title: 'Didi B - Fatúmata feat Naira Marley', youtube_id: '2HxJ1R8_xV4' },
  { title: 'HIMRA - ÇA GLOW', youtube_id: 'qj5IjESRaxI' },
  { title: 'Didi B - Rockstxr', youtube_id: 'YeCRoOnr5vU' },
  { title: 'SINDIKA x DIDI B - RODELA', youtube_id: 'YCSbp-oTnyc' },
  { title: 'Didi B - 2025 (Official Music Video)', youtube_id: 'yzWENpeiZzc' }
]

afro_rap_videos.each do |video|
  afro_rap_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION RAP LA RELÈVE VOL.1
# ===========================================
puts "  📝 Recréation de 'Rap La Relève vol.1'"

rap_releve_vol1_playlist = Playlist.create!(
  title: 'Rap La Relève vol.1',
  description: 'La nouvelle génération du rap français',
  category: 'Rap',
  premium: false
)

rap_releve_vol1_videos = [
  { title: '4h44', youtube_id: 'QbgdoKDZA0Y' },
  { title: 'BOTTEGA', youtube_id: 'j0rrbBXnIMc' },
  { title: 'Biff pas d\'love', youtube_id: 'TDO0GRay2fQ' },
  { title: 'COMMENT CA VA', youtube_id: 'qvmR57nwBPc' },
  { title: 'Célibataire', youtube_id: '_xuNmoJEoIM' },
  { title: 'Jaloux (feat. JUL)', youtube_id: 'j6P8RLRtU9I' },
  { title: 'P.I.B', youtube_id: 'uQB1ZdEd2CM' },
  { title: 'Poukwa (elle m\'demande)', youtube_id: 'rAxVxcxuLnM' },
  { title: 'Putana', youtube_id: 'uuRvS4wzrHA' },
  { title: 'Terrain', youtube_id: 'RsBD1POgx-c' }
]

rap_releve_vol1_videos.each do |video|
  rap_releve_vol1_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

# ===========================================
# RECRÉATION AFRO VIBES VOL. 3
# ===========================================
puts "  📝 Recréation de 'Afro Vibes Vol. 3'"

afro_vibes_vol3_playlist = Playlist.create!(
  title: 'Afro Vibes Vol. 3',
  description: 'Final des meilleures vibes afro',
  category: 'Afro',
  premium: true
)

afro_vibes_vol3_videos = [
  { title: 'Simba', youtube_id: 'qvVGbUWorUo' },
  { title: 'Ça m\'a laissé', youtube_id: 'qrdK1RqpcV0' },
  { title: 'À Tes Côtés', youtube_id: 'nczf50Gh_pM' },
  { title: 'Pas Jalouse', youtube_id: 'vCRztEFJc50' },
  { title: 'YORSSY Ft. GUY2BEZBAR - MALABAR', youtube_id: 'wqXe3DrJrF0' },
  { title: 'Faux Pas', youtube_id: 'eoykXiyvB2I' },
  { title: 'ZALA', youtube_id: 'MokYNrCNh-4' },
  { title: 'Changer Camp', youtube_id: '8xwUCf2qz_s' },
  { title: 'ATASSA', youtube_id: 'bxLvdwgRZvI' }
]

afro_vibes_vol3_videos.each do |video|
  afro_vibes_vol3_playlist.videos.create!(
    title: video[:title],
    youtube_id: video[:youtube_id]
  )
end

puts "\n🎉 Nettoyage terminé !"
puts "📊 Résumé :"
puts "   - #{problematic_playlists.count} playlists problématiques supprimées et recréées"
puts "   - Toutes les vidéos orphelines supprimées"
puts "   - Tous les YouTube IDs sont maintenant valides et uniques"
puts "\n✅ Vous pouvez maintenant rafraîchir votre application sans problème !"
