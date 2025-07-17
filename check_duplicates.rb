#!/usr/bin/env ruby

# Script pour vérifier les doublons dans les playlists
puts "🔍 Vérification des doublons dans les playlists..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Vérifier la playlist "This is AfroPop"
playlist = Playlist.find_by(title: 'This is AfroPop')
if playlist.nil?
  puts "❌ Playlist 'This is AfroPop' non trouvée"
  exit 1
end

puts "📋 Playlist: #{playlist.title}"
puts "🎵 Nombre total de vidéos: #{playlist.videos.count}"

# Vérifier les doublons par youtube_id
duplicates_by_youtube_id = playlist.videos.group(:youtube_id).having('count(*) > 1')
puts "\n🔍 Doublons par youtube_id:"
if duplicates_by_youtube_id.any?
  duplicates_by_youtube_id.each do |group|
    youtube_id = group.youtube_id
    count = group.count
    videos = playlist.videos.where(youtube_id: youtube_id)
    puts "  - youtube_id: #{youtube_id} (#{count} fois)"
    videos.each do |video|
      puts "    * #{video.title} (ID: #{video.id})"
    end
  end
else
  puts "  ✅ Aucun doublon par youtube_id"
end

# Vérifier les doublons par titre
duplicates_by_title = playlist.videos.group(:title).having('count(*) > 1')
puts "\n🔍 Doublons par titre:"
if duplicates_by_title.any?
  duplicates_by_title.each do |group|
    title = group.title
    videos = playlist.videos.where(title: title)
    count = videos.count
    puts "  - titre: #{title} (#{count} fois)"
    videos.each do |video|
      puts "    * youtube_id: #{video.youtube_id} (ID: #{video.id})"
    end
  end
else
  puts "  ✅ Aucun doublon par titre"
end

# Afficher toutes les vidéos de la playlist
puts "\n📋 Toutes les vidéos de la playlist:"
playlist.videos.order(:id).each do |video|
  puts "  #{video.id}: #{video.title} (#{video.youtube_id})"
end 