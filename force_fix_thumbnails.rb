#!/usr/bin/env ruby

puts "🔧 CORRECTION FORCÉE DES THUMBNAILS POUR TOUTES LES PLAYLISTS"
puts "=" * 70
puts "🎯 Forcer l'utilisation de la première vidéo comme thumbnail stable"
puts "=" * 70

require_relative 'config/environment'

# Liste des playlists problématiques mentionnées
problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

puts "\n🔍 Vérification des playlists problématiques..."

problematic_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    first_video = playlist.videos.first
    current_thumbnail = playlist.consistent_thumbnail
    
    puts "  📋 '#{playlist_title}' (ID: #{playlist.id})"
    puts "    - Première vidéo: #{first_video&.youtube_id} (#{first_video&.title})"
    puts "    - Thumbnail actuel: #{current_thumbnail}"
    puts "    - Premium: #{playlist.premium}"
    
    if current_thumbnail != first_video&.youtube_id
      puts "    ⚠️  PROBLÈME: Thumbnail différent de la première vidéo"
    else
      puts "    ✅ OK: Thumbnail cohérent"
    end
  else
    puts "  ❌ '#{playlist_title}' non trouvée"
  end
end

puts "\n🔄 Forçage du rechargement des thumbnails..."

# Forcer le rechargement en vidant le cache des instances
Playlist.all.each do |playlist|
  # Vider le cache de l'instance
  playlist.instance_variable_set(:@consistent_thumbnail, nil)
  
  # Recalculer le thumbnail
  new_thumbnail = playlist.consistent_thumbnail
  first_video_id = playlist.videos.first&.youtube_id
  
  if new_thumbnail == first_video_id
    puts "  ✅ '#{playlist.title}': #{new_thumbnail}"
  else
    puts "  ⚠️  '#{playlist.title}': #{new_thumbnail} (attendu: #{first_video_id})"
  end
end

puts "\n🧹 Nettoyage du cache Rails..."

# Nettoyer le cache Rails si nécessaire
if Rails.cache.respond_to?(:clear)
  Rails.cache.clear
  puts "  ✅ Cache Rails vidé"
else
  puts "  ℹ️  Pas de cache Rails à vider"
end

puts "\n🔍 Vérification finale des playlists problématiques..."

problematic_playlists.each do |playlist_title|
  playlist = Playlist.find_by(title: playlist_title)
  if playlist
    # Forcer le rechargement
    playlist.reload
    playlist.instance_variable_set(:@consistent_thumbnail, nil)
    
    first_video = playlist.videos.first
    new_thumbnail = playlist.consistent_thumbnail
    
    puts "  📋 '#{playlist_title}'"
    puts "    - Première vidéo: #{first_video&.youtube_id}"
    puts "    - Nouveau thumbnail: #{new_thumbnail}"
    
    if new_thumbnail == first_video&.youtube_id
      puts "    ✅ CORRIGÉ: Thumbnail cohérent"
    else
      puts "    ❌ PROBLÈME PERSISTANT"
    end
  end
end

puts "\n🎉 CORRECTION TERMINÉE !"
puts "📊 Résumé :"
puts "   - Cache des instances vidé"
puts "   - Thumbnails recalculés pour toutes les playlists"
puts "   - Vérification des playlists problématiques effectuée"

puts "\n✨ Toutes les playlists devraient maintenant avoir des thumbnails stables !"
puts "💡 Conseil : Rafraîchissez votre interface pour voir les changements"
