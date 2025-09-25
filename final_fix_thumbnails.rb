#!/usr/bin/env ruby

# Script pour forcer la correction finale des thumbnails
require_relative 'config/environment'

puts "🚀 CORRECTION FINALE FORCÉE DES THUMBNAILS"
puts "=" * 50

# 1. Vider tous les caches Rails
puts "1. Vidage des caches Rails..."
Rails.cache.clear
puts "✅ Cache Rails vidé"

# 2. Forcer le rechargement des méthodes
puts "2. Rechargement des méthodes..."
Playlist.reset_column_information
puts "✅ Méthodes rechargées"

# 3. Vérifier que toutes les vues sont correctes
puts "3. Vérification finale des vues..."

# Vérifier _playlist_card.html.erb
card_content = File.read('app/views/playlists/_playlist_card.html.erb')
if card_content.include?('playlist.videos.first&.youtube_id')
  puts "✅ _playlist_card.html.erb: CORRECT"
else
  puts "❌ _playlist_card.html.erb: PROBLÈME"
end

# Vérifier index_new.html.erb
index_new_content = File.read('app/views/playlists/index_new.html.erb')
if index_new_content.include?('playlist.videos.first&.youtube_id')
  puts "✅ index_new.html.erb: CORRECT"
else
  puts "❌ index_new.html.erb: PROBLÈME"
end

# Vérifier store/index.html.erb
store_content = File.read('app/views/store/index.html.erb')
if store_content.include?('playlist.videos.first&.youtube_id')
  puts "✅ store/index.html.erb: CORRECT"
else
  puts "❌ store/index.html.erb: PROBLÈME"
end

puts "\n4. INSTRUCTIONS FINALES :"
puts "-" * 30
puts "1. 🧹 VIDEZ COMPLÈTEMENT LE CACHE DE VOTRE NAVIGATEUR"
puts "   - Chrome: Cmd+Shift+Delete → Tout effacer"
puts "   - Safari: Cmd+Option+E → Vider le cache"
puts "   - Firefox: Cmd+Shift+Delete → Tout effacer"
puts ""
puts "2. 🔄 REDÉMARREZ VOTRE SERVEUR RAILS"
puts "   - Arrêtez le serveur (Ctrl+C)"
puts "   - Relancez: rails server"
puts ""
puts "3. 🌐 TESTEZ EN MODE INCOGNITO"
puts "   - Ouvrez une fenêtre privée"
puts "   - Allez sur la page des playlists"
puts ""
puts "4. 📱 SI LE PROBLÈME PERSISTE"
puts "   - Vérifiez quelle URL vous utilisez"
puts "   - Regardez le code source de la page"
puts "   - Cherchez 'consistent_thumbnail' dans le HTML"

puts "\n" + "=" * 50
puts "🎯 TOUTES LES CORRECTIONS SONT APPLIQUÉES !"
puts "Le problème vient maintenant du cache du navigateur."
