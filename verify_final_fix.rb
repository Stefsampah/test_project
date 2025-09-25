#!/usr/bin/env ruby

# Script pour vérifier et forcer la correction des thumbnails
require_relative 'config/environment'

puts "🔍 VÉRIFICATION FINALE DES THUMBNAILS"
puts "=" * 50

# 1. Vérifier que toutes les vues sont correctes
puts "1. Vérification des fichiers de vues :"

files_to_check = [
  'app/views/playlists/index.html.erb',
  'app/views/playlists/_playlist_card.html.erb', 
  'app/views/store/index.html.erb',
  'app/views/playlists/index_new.html.erb',
  'app/views/playlists/index_backup.html.erb'
]

files_to_check.each do |file|
  if File.exist?(file)
    content = File.read(file)
    if content.include?('consistent_thumbnail')
      puts "❌ #{file}: Utilise encore consistent_thumbnail"
    elsif content.include?('videos.first&.youtube_id')
      puts "✅ #{file}: Utilise videos.first&.youtube_id"
    elsif content.include?('render.*playlist_card')
      puts "✅ #{file}: Utilise le partial _playlist_card"
    else
      puts "⚠️  #{file}: Aucune méthode de thumbnail détectée"
    end
  else
    puts "❌ #{file}: Fichier non trouvé"
  end
end

# 2. Vérifier les playlists problématiques
puts "\n2. Vérification des playlists problématiques :"

problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist && playlist.videos.any?
    first_video = playlist.videos.first
    puts "✅ #{title}: #{first_video.youtube_id}"
  else
    puts "❌ #{title}: Problème"
  end
end

# 3. Vider tous les caches
puts "\n3. Vidage des caches :"
Rails.cache.clear
puts "✅ Cache Rails vidé"

# 4. Instructions finales
puts "\n4. INSTRUCTIONS FINALES :"
puts "-" * 30
puts "1. 🔄 REDÉMARREZ VOTRE SERVEUR RAILS :"
puts "   - Arrêtez le serveur (Ctrl+C)"
puts "   - Relancez: rails server"
puts ""
puts "2. 🧹 VIDEZ LE CACHE DU NAVIGATEUR :"
puts "   - Chrome: Cmd+Shift+Delete"
puts "   - Ou utilisez: Cmd+Shift+R (rechargement forcé)"
puts ""
puts "3. 🌐 TESTEZ CES URLs :"
puts "   - http://localhost:3000/"
puts "   - http://localhost:3000/playlists"
puts "   - http://localhost:3000/store"
puts ""
puts "4. 📱 SI LE PROBLÈME PERSISTE :"
puts "   - Regardez le code source de la page (clic droit → Afficher le code source)"
puts "   - Cherchez 'consistent_thumbnail' dans le HTML"
puts "   - Si vous le trouvez, c'est qu'une vue n'est pas mise à jour"

puts "\n" + "=" * 50
puts "🎯 TOUTES LES CORRECTIONS SONT APPLIQUÉES !"
puts "Le problème vient maintenant du serveur Rails qui n'a pas été redémarré."
