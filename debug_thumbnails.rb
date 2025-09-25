#!/usr/bin/env ruby

# Script de débogage pour identifier le problème des thumbnails
require_relative 'config/environment'

puts "🔍 DÉBOGAGE DES THUMBNAILS - ANALYSE COMPLÈTE"
puts "=" * 60

# Vérifier les playlists problématiques
problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

puts "1. VÉRIFICATION DES PLAYLISTS :"
puts "-" * 40

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist
    puts "\n📁 #{title}:"
    puts "   ID: #{playlist.id}"
    puts "   Premium: #{playlist.premium?}"
    puts "   Exclusive: #{playlist.exclusive?}"
    puts "   Hidden: #{playlist.hidden?}"
    puts "   Nombre de vidéos: #{playlist.videos.count}"
    
    if playlist.videos.any?
      first_video = playlist.videos.first
      puts "   Première vidéo: #{first_video.title}"
      puts "   YouTube ID: #{first_video.youtube_id}"
      puts "   URL thumbnail: https://img.youtube.com/vi/#{first_video.youtube_id}/maxresdefault.jpg"
      
      # Tester la méthode consistent_thumbnail
      puts "   consistent_thumbnail: #{playlist.consistent_thumbnail}"
      puts "   first_thumbnail: #{playlist.first_thumbnail}"
    else
      puts "   ❌ AUCUNE VIDÉO DANS CETTE PLAYLIST !"
    end
  else
    puts "\n❌ #{title}: PLAYLIST NON TROUVÉE"
  end
end

puts "\n2. VÉRIFICATION DES MÉTHODES DU MODÈLE :"
puts "-" * 40

# Tester les méthodes sur une playlist
test_playlist = Playlist.find_by(title: 'Afro Vibes Vol. 1')
if test_playlist
  puts "Test sur: #{test_playlist.title}"
  puts "consistent_thumbnail: #{test_playlist.consistent_thumbnail}"
  puts "first_thumbnail: #{test_playlist.first_thumbnail}"
  puts "random_thumbnail: #{test_playlist.random_thumbnail}"
end

puts "\n3. VÉRIFICATION DES FICHIERS DE VUES :"
puts "-" * 40

view_files = [
  'app/views/playlists/index.html.erb',
  'app/views/playlists/index_new.html.erb', 
  'app/views/playlists/index_backup.html.erb',
  'app/views/playlists/_playlist_card.html.erb',
  'app/views/store/index.html.erb'
]

view_files.each do |file|
  if File.exist?(file)
    content = File.read(file)
    if content.include?('consistent_thumbnail')
      puts "❌ #{file}: Utilise encore consistent_thumbnail"
    elsif content.include?('videos.first&.youtube_id')
      puts "✅ #{file}: Utilise videos.first&.youtube_id"
    else
      puts "⚠️  #{file}: Aucune méthode de thumbnail détectée"
    end
  else
    puts "❌ #{file}: Fichier non trouvé"
  end
end

puts "\n4. RECOMMANDATIONS :"
puts "-" * 40
puts "1. Videz complètement le cache de votre navigateur"
puts "2. Utilisez le mode incognito pour tester"
puts "3. Vérifiez quelle vue est réellement utilisée"
puts "4. Redémarrez le serveur Rails si nécessaire"

puts "=" * 60
