#!/usr/bin/env ruby

# Script pour corriger l'ID YouTube de la vidéo "NO CAP"
require_relative 'config/environment'

puts "🔧 Correction de l'ID YouTube pour 'NO CAP'"
puts "=" * 50

# Rechercher la vidéo avec l'ancien ID
video = Video.find_by(youtube_id: '-Q4kCS4u9b8')

if video
  puts "📹 Vidéo trouvée: #{video.title}"
  puts "   Ancien ID: #{video.youtube_id}"
  
  # Vérifier si le nouvel ID existe déjà
  existing_video = Video.find_by(youtube_id: 'Q4kCS4u9b8')
  if existing_video && existing_video.id != video.id
    puts "⚠️  ATTENTION: Une vidéo avec l'ID 'Q4kCS4u9b8' existe déjà: #{existing_video.title}"
    puts "   Action: Suppression de l'ancienne vidéo avec ID invalide"
    video.destroy
    puts "✅ Ancienne vidéo supprimée"
  else
    video.update!(youtube_id: 'Q4kCS4u9b8')
    puts "   Nouveau ID: #{video.youtube_id}"
    puts "✅ Vidéo mise à jour avec succès!"
  end
else
  puts "ℹ️  Aucune vidéo avec l'ID '-Q4kCS4u9b8' trouvée"
  puts "   La vidéo a peut-être déjà été corrigée ou n'existe pas encore"
end

puts "\n✅ Script terminé"

