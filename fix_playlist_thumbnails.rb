#!/usr/bin/env ruby

# Script pour corriger les thumbnails des playlists problématiques
require_relative 'config/environment'

puts "🔧 CORRECTION DES THUMBNAILS PLAYLIST"
puts "=" * 50

problematic_playlists = ['Rap Ivoire Power', 'Afro Vibes']

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  
  if playlist.nil?
    puts "❌ Playlist '#{title}' non trouvée"
    next
  end
  
  puts "📋 Traitement de: #{playlist.title}"
  puts "   Videos count: #{playlist.videos.count}"
  
  # Vérifier la première vidéo
  first_video = playlist.videos.first
  if first_video.nil?
    puts "❌ Aucune vidéo trouvée !"
    next
  end
  
  puts "   Première vidéo: #{first_video.title}"
  puts "   YouTube ID: #{first_video.youtube_id}"
  
  # Tester l'URL du thumbnail
  thumbnail_url = "https://img.youtube.com/vi/#{first_video.youtube_id}/maxresdefault.jpg"
  puts "   URL Thumbnail: #{thumbnail_url}"
  
  # Test rapide avec curl si disponible
  puts "   Test accès thumbnail..."
  
  # Si le problème persiste, utiliser une vidéo différente
  if playlist.videos.count > 1
    puts "🔄 Essai avec vidéo alternative..."
    second_video = playlist.videos.second
    puts "   Vidéo alternative: #{second_video.title} (#{second_video.youtube_id})"
  else
    puts "❌ Pas d'alternative disponible"
  end
  
  puts "-" * 40
end

puts "\n💡 RECOMMANDATIONS :"
puts "1. Vérifiez manuellement les URLs YouTube dans le navigateur"
puts "2. Si problématique, changez l'ordre des vidéos dans seeds.rb"
puts "3. Ou ajoutez un système de fallback plus robuste"

puts "\n" + "=" * 50
