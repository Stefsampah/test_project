#!/usr/bin/env ruby

# Script pour identifier quelle vue est réellement utilisée
require_relative 'config/environment'

puts "🔍 IDENTIFICATION DE LA VUE UTILISÉE"
puts "=" * 50

# Vérifier les routes
puts "1. ROUTES DISPONIBLES :"
puts "-" * 30
puts "Root (/) → playlists#index"
puts "/playlists → playlists#index" 
puts "/store → store#index"

# Vérifier le contrôleur
puts "\n2. CONTRÔLEUR PLAYLISTS :"
puts "-" * 30
controller_content = File.read('app/controllers/playlists_controller.rb')
if controller_content.include?('render')
  puts "Le contrôleur utilise des render explicites"
else
  puts "Le contrôleur utilise les vues par défaut"
end

# Vérifier s'il y a des redirects ou des conditions
if controller_content.include?('redirect_to')
  puts "⚠️  Le contrôleur contient des redirects"
end

if controller_content.include?('render :')
  puts "⚠️  Le contrôleur contient des renders explicites"
end

# Vérifier les vues
puts "\n3. VUES DISPONIBLES :"
puts "-" * 30
view_files = Dir.glob('app/views/playlists/*.erb')
view_files.each do |file|
  puts "📁 #{file}"
end

puts "\n4. RECOMMANDATIONS :"
puts "-" * 30
puts "1. Vérifiez quelle URL vous utilisez exactement"
puts "2. Regardez le code source de la page"
puts "3. Cherchez 'index_new' dans le HTML généré"
puts "4. Si vous trouvez 'index_new', c'est cette vue qui est utilisée"

puts "\n" + "=" * 50
