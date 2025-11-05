#!/usr/bin/env ruby

# Script pour supprimer la vidéo "Si tu pars" avec l'ID invalide XILS3CclI1k
require_relative 'config/environment'

puts "🔧 Suppression de la vidéo invalide de RELEASED vol.2"
puts "=" * 60

playlist = Playlist.find_by(title: 'RELEASED vol.2')

if playlist.nil?
  puts "❌ Playlist 'RELEASED vol.2' non trouvée"
  exit
end

puts "📋 Playlist trouvée: #{playlist.title}"

# Rechercher la vidéo avec l'ID invalide
invalid_video = playlist.videos.find_by(youtube_id: 'XILS3CclI1k')

if invalid_video
  puts "❌ Vidéo invalide trouvée: #{invalid_video.title}"
  puts "   ID: #{invalid_video.youtube_id}"
  
  # Supprimer les swipes associés si nécessaire
  if invalid_video.respond_to?(:swipes)
    swipe_count = invalid_video.swipes.count
    if swipe_count > 0
      puts "   Suppression de #{swipe_count} swipe(s) associé(s)..."
      invalid_video.swipes.destroy_all
    end
  end
  
  # Supprimer la vidéo
  invalid_video.destroy
  puts "✅ Vidéo supprimée avec succès"
else
  puts "ℹ️  Aucune vidéo avec l'ID 'XILS3CclI1k' trouvée"
end

puts "\n🔍 Vérification du thumbnail après suppression..."
valid_videos = playlist.videos.select { |v| v.youtube_id.present? && v.youtube_id.length >= 10 && !v.youtube_id.start_with?('-') }
puts "   Vidéos valides restantes: #{valid_videos.count}"

if valid_videos.empty?
  puts "❌ Aucune vidéo valide trouvée dans la playlist!"
else
  thumbnail_id = playlist.valid_thumbnail_id
  first_valid = valid_videos.first
  puts "\n✅ Nouvelle première vidéo valide: #{first_valid.title}"
  puts "   ID: #{first_valid.youtube_id}"
  puts "   Thumbnail ID: #{thumbnail_id}"
  puts "   URL thumbnail: https://img.youtube.com/vi/#{thumbnail_id}/hqdefault.jpg"
end

puts "\n✅ Script terminé"

