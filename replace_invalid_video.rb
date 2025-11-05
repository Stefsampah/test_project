#!/usr/bin/env ruby

# Script pour remplacer la vidéo "Si tu pars" avec l'ID invalide par la nouvelle vidéo
require_relative 'config/environment'

puts "🔧 Remplacement de la vidéo invalide dans RELEASED vol.2"
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
  puts "   Ancien ID: #{invalid_video.youtube_id}"
  
  # Vérifier si la nouvelle vidéo existe déjà
  existing_video = playlist.videos.find_by(youtube_id: '0Rl8lrbCyKM')
  if existing_video
    puts "⚠️  Une vidéo avec l'ID '0Rl8lrbCyKM' existe déjà: #{existing_video.title}"
    puts "   Suppression de la vidéo invalide..."
    
    # Supprimer les swipes associés si nécessaire
    if invalid_video.respond_to?(:swipes)
      swipe_count = invalid_video.swipes.count
      if swipe_count > 0
        puts "   Suppression de #{swipe_count} swipe(s) associé(s)..."
        invalid_video.swipes.destroy_all
      end
    end
    
    invalid_video.destroy
    puts "✅ Vidéo invalide supprimée"
  else
    # Mettre à jour l'ID de la vidéo
    invalid_video.update!(youtube_id: '0Rl8lrbCyKM')
    puts "   Nouveau ID: #{invalid_video.youtube_id}"
    puts "✅ Vidéo mise à jour avec succès!"
  end
else
  puts "ℹ️  Aucune vidéo avec l'ID 'XILS3CclI1k' trouvée"
  
  # Vérifier si la nouvelle vidéo existe déjà
  existing_video = playlist.videos.find_by(youtube_id: '0Rl8lrbCyKM')
  if existing_video
    puts "✅ La vidéo avec l'ID '0Rl8lrbCyKM' existe déjà: #{existing_video.title}"
  else
    puts "⚠️  La nouvelle vidéo n'existe pas encore dans la playlist"
  end
end

puts "\n🔍 Vérification du thumbnail après correction..."
valid_videos = playlist.videos.select { |v| v.youtube_id.present? && v.youtube_id.length >= 10 && !v.youtube_id.start_with?('-') }
puts "   Vidéos valides: #{valid_videos.count}"

if valid_videos.empty?
  puts "❌ Aucune vidéo valide trouvée dans la playlist!"
else
  thumbnail_id = playlist.valid_thumbnail_id
  first_valid = valid_videos.first
  puts "\n✅ Première vidéo valide: #{first_valid.title}"
  puts "   ID: #{first_valid.youtube_id}"
  puts "   Thumbnail ID: #{thumbnail_id}"
  puts "   URL thumbnail: https://img.youtube.com/vi/#{thumbnail_id}/hqdefault.jpg"
  
  # Vérifier l'URL du thumbnail
  if thumbnail_id == '0Rl8lrbCyKM'
    puts "\n✅ La nouvelle vidéo est maintenant utilisée pour le thumbnail!"
  end
end

puts "\n📊 Résumé de la playlist:"
puts "   Total vidéos: #{playlist.videos.count}"
playlist.videos.order(:id).each_with_index do |video, index|
  puts "   #{index + 1}. #{video.title} - ID: #{video.youtube_id}"
end

puts "\n✅ Script terminé"

