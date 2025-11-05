#!/usr/bin/env ruby

# Script pour corriger l'ID YouTube de la vidéo "NO CAP" dans RELEASED vol.2
require_relative 'config/environment'

puts "🔧 Correction de la playlist RELEASED vol.2"
puts "=" * 60

playlist = Playlist.find_by(title: 'RELEASED vol.2')

if playlist.nil?
  puts "❌ Playlist 'RELEASED vol.2' non trouvée"
  exit
end

puts "📋 Playlist trouvée: #{playlist.title}"
puts "   Nombre de vidéos: #{playlist.videos.count}"
puts "\n📹 Liste des vidéos actuelle:"
playlist.videos.each_with_index do |video, index|
  puts "   #{index + 1}. #{video.title} - ID: #{video.youtube_id}"
end

puts "\n🔍 Recherche de la vidéo avec l'ancien ID..."
video_with_bad_id = playlist.videos.find_by(youtube_id: '-Q4kCS4u9b8')

if video_with_bad_id
  puts "❌ Vidéo trouvée avec l'ancien ID: #{video_with_bad_id.title}"
  puts "   Ancien ID: #{video_with_bad_id.youtube_id}"
  
  # Vérifier si le nouvel ID existe déjà
  existing_video = playlist.videos.find_by(youtube_id: 'Q4kCS4u9b8')
  if existing_video && existing_video.id != video_with_bad_id.id
    puts "⚠️  Une vidéo avec l'ID 'Q4kCS4u9b8' existe déjà (#{existing_video.title})"
    puts "   Mise à jour de l'ancienne vidéo avec un ID temporaire, puis suppression du doublon..."
    
    # Mettre à jour l'ancienne vidéo avec un ID temporaire
    video_with_bad_id.update!(youtube_id: 'TEMP_DELETE_' + video_with_bad_id.id.to_s)
    puts "   Ancienne vidéo mise à jour avec ID temporaire"
    
    # Supprimer les swipes associés à cette vidéo si nécessaire
    video_with_bad_id.swipes.destroy_all if video_with_bad_id.respond_to?(:swipes)
    
    # Maintenant supprimer la vidéo
    video_with_bad_id.destroy
    puts "✅ Vidéo supprimée"
  else
    video_with_bad_id.update!(youtube_id: 'Q4kCS4u9b8')
    puts "   Nouveau ID: #{video_with_bad_id.youtube_id}"
    puts "✅ Vidéo mise à jour avec succès!"
  end
else
  puts "✅ Aucune vidéo avec l'ancien ID trouvée"
end

puts "\n🔍 Vérification des vidéos valides pour le thumbnail..."
valid_videos = playlist.videos.select { |v| v.youtube_id.present? && v.youtube_id.length >= 10 && !v.youtube_id.start_with?('-') }
puts "   Vidéos valides trouvées: #{valid_videos.count}"

if valid_videos.empty?
  puts "❌ Aucune vidéo valide trouvée dans la playlist!"
else
  puts "\n📋 Liste des vidéos valides:"
  valid_videos.each_with_index do |video, index|
    puts "   #{index + 1}. #{video.title} - ID: #{video.youtube_id}"
  end
  
  thumbnail_id = playlist.valid_thumbnail_id
  first_valid = valid_videos.first
  puts "\n✅ Première vidéo valide: #{first_valid.title}"
  puts "   ID: #{first_valid.youtube_id}"
  puts "   Thumbnail ID retourné par valid_thumbnail_id: #{thumbnail_id}"
  puts "   URL thumbnail: https://img.youtube.com/vi/#{thumbnail_id}/hqdefault.jpg" if thumbnail_id
  
  # Vérifier si la première vidéo actuelle est valide
  current_first = playlist.videos.first
  if current_first && current_first.youtube_id == thumbnail_id
    puts "\n✅ La première vidéo actuelle est valide, le thumbnail devrait fonctionner"
  elsif current_first
    puts "\n⚠️  La première vidéo actuelle (#{current_first.title} - #{current_first.youtube_id}) n'est pas utilisée pour le thumbnail"
    puts "   Le thumbnail utilisera: #{thumbnail_id}"
  end
end

puts "\n✅ Script terminé"

