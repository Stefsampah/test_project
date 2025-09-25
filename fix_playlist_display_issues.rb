#!/usr/bin/env ruby

puts "🔧 NETTOYAGE DES DOUBLONS DE PLAYLISTS"
puts "=" * 50
puts "🎯 Résolution des problèmes d'affichage et de doublons"
puts "=" * 50

require_relative 'config/environment'

# Identification des playlists problématiques
problematic_playlists = [
  { current: 'Afro Vibes', new: 'Afro Vibes Premium', id: 35 },
  { current: 'Afro Vibes Vol. 1', new: 'Afro Vibes Vol. 1', id: 6 },
  { current: 'Afro Vibes Vol. 3', new: 'Afro Vibes Vol. 3', id: 8 }
]

puts "\n🔍 Vérification des playlists problématiques..."

problematic_playlists.each do |playlist_info|
  playlist = Playlist.find_by(id: playlist_info[:id])
  if playlist
    puts "  📋 '#{playlist.title}' (ID: #{playlist.id}) - #{playlist.videos.count} vidéos - Premium: #{playlist.premium}"
  else
    puts "  ⚠️  Playlist ID #{playlist_info[:id]} non trouvée"
  end
end

puts "\n🔄 Renommage des playlists pour éviter la confusion..."

# Renommer "Afro Vibes" en "Afro Vibes Premium" pour éviter la confusion
afro_vibes_premium = Playlist.find_by(title: 'Afro Vibes')
if afro_vibes_premium
  old_title = afro_vibes_premium.title
  afro_vibes_premium.update!(title: 'Afro Vibes Premium')
  puts "  ✅ Renommé '#{old_title}' → 'Afro Vibes Premium'"
end

puts "\n🔍 Vérification des autres playlists similaires..."

# Vérifier s'il y a d'autres playlists avec des noms similaires
similar_playlists = Playlist.where("title LIKE ?", "%Afro Vibes%").pluck(:title, :id, :premium)
puts "  📋 Playlists contenant 'Afro Vibes':"
similar_playlists.each do |title, id, premium|
  puts "    - '#{title}' (ID: #{id}) - Premium: #{premium}"
end

puts "\n🧹 Nettoyage des vidéos orphelines..."
orphaned_videos = Video.left_joins(:playlist).where(playlists: { id: nil })
puts "  🗑️ Suppression de #{orphaned_videos.count} vidéos orphelines"
orphaned_videos.destroy_all

puts "\n🔍 Vérification finale des playlists..."

# Vérifier que toutes les playlists ont des noms uniques
all_playlists = Playlist.pluck(:title, :id, :premium)
duplicate_names = all_playlists.group_by(&:first).select { |k, v| v.size > 1 }

if duplicate_names.any?
  puts "  ⚠️  Noms de playlists en doublon détectés:"
  duplicate_names.each do |name, playlists|
    puts "    - '#{name}': #{playlists.map { |p| "ID #{p[1]} (Premium: #{p[2]})" }.join(', ')}"
  end
else
  puts "  ✅ Tous les noms de playlists sont uniques"
end

puts "\n🎉 NETTOYAGE TERMINÉ !"
puts "📊 Résumé :"
puts "   - Playlists renommées pour éviter la confusion"
puts "   - Vidéos orphelines supprimées"
puts "   - Vérification des doublons effectuée"

puts "\n✨ Les problèmes d'affichage devraient être résolus !"
puts "💡 Conseil : Rafraîchissez votre interface pour voir les changements"
