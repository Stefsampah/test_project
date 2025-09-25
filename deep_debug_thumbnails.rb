#!/usr/bin/env ruby

# Script de débogage approfondi pour identifier le problème
require_relative 'config/environment'

puts "🔍 DÉBOGAGE APPROFONDI - IDENTIFICATION DU PROBLÈME"
puts "=" * 60

# 1. Vérifier toutes les méthodes du modèle Playlist
puts "1. VÉRIFICATION DU MODÈLE PLAYLIST :"
puts "-" * 40

playlist = Playlist.find_by(title: 'Afro Vibes Vol. 1')
if playlist
  puts "Playlist trouvée: #{playlist.title}"
  puts "ID: #{playlist.id}"
  puts "Nombre de vidéos: #{playlist.videos.count}"
  
  if playlist.videos.any?
    puts "\nPremières 3 vidéos:"
    playlist.videos.limit(3).each_with_index do |video, index|
      puts "  #{index + 1}. #{video.title} - #{video.youtube_id}"
    end
    
    puts "\nMéthodes du modèle:"
    puts "  first_thumbnail: #{playlist.first_thumbnail}"
    puts "  consistent_thumbnail: #{playlist.consistent_thumbnail}"
    puts "  random_thumbnail: #{playlist.random_thumbnail}"
  end
end

# 2. Vérifier s'il y a des méthodes cachées ou des callbacks
puts "\n2. VÉRIFICATION DES MÉTHODES CACHÉES :"
puts "-" * 40

# Lire le fichier du modèle pour voir s'il y a des méthodes cachées
model_content = File.read('app/models/playlist.rb')
puts "Contenu du modèle Playlist:"
puts model_content

# 3. Vérifier tous les fichiers de vues
puts "\n3. VÉRIFICATION COMPLÈTE DES VUES :"
puts "-" * 40

view_files = Dir.glob('app/views/**/*.erb')
view_files.each do |file|
  content = File.read(file)
  if content.include?('consistent_thumbnail') || content.include?('random_thumbnail') || content.include?('videos.sample')
    puts "❌ #{file}: Contient des méthodes problématiques"
    # Afficher les lignes problématiques
    content.lines.each_with_index do |line, index|
      if line.include?('consistent_thumbnail') || line.include?('random_thumbnail') || line.include?('videos.sample')
        puts "   Ligne #{index + 1}: #{line.strip}"
      end
    end
  end
end

# 4. Vérifier les helpers
puts "\n4. VÉRIFICATION DES HELPERS :"
puts "-" * 40

helper_files = Dir.glob('app/helpers/**/*.rb')
helper_files.each do |file|
  content = File.read(file)
  if content.include?('consistent_thumbnail') || content.include?('random_thumbnail') || content.include?('videos.sample')
    puts "❌ #{file}: Contient des méthodes problématiques"
  end
end

# 5. Vérifier les contrôleurs
puts "\n5. VÉRIFICATION DES CONTRÔLEURS :"
puts "-" * 40

controller_files = Dir.glob('app/controllers/**/*.rb')
controller_files.each do |file|
  content = File.read(file)
  if content.include?('consistent_thumbnail') || content.include?('random_thumbnail') || content.include?('videos.sample')
    puts "❌ #{file}: Contient des méthodes problématiques"
  end
end

puts "\n6. RECOMMANDATIONS :"
puts "-" * 40
puts "1. Vérifiez quelle URL vous utilisez exactement"
puts "2. Regardez le code source de la page (clic droit → Afficher le code source)"
puts "3. Cherchez 'consistent_thumbnail' dans le HTML généré"
puts "4. Vérifiez s'il y a des JavaScript qui modifient les images"

puts "\n" + "=" * 60
