#!/usr/bin/env ruby
# Script pour exporter les avatars des utilisateurs depuis Active Storage

require 'json'
require 'base64'

puts "📤 Export des avatars des utilisateurs..."
puts "=" * 80

avatars_data = []

User.all.each do |user|
  if user.avatar.attached?
    begin
      # Lire le fichier avatar
      avatar_file = user.avatar.download
      filename = user.avatar.filename.to_s
      content_type = user.avatar.content_type
      
      # Encoder en base64 pour le transfert
      avatar_base64 = Base64.strict_encode64(avatar_file)
      
      avatars_data << {
        email: user.email,
        filename: filename,
        content_type: content_type,
        data: avatar_base64
      }
      
      puts "✅ #{user.email}: #{filename} (#{avatar_file.length} bytes)"
    rescue => e
      puts "❌ Erreur pour #{user.email}: #{e.message}"
    end
  else
    puts "⚠️  #{user.email}: Pas d'avatar"
  end
end

# Sauvegarder dans un fichier JSON
File.write('tmp/avatars_export.json', JSON.pretty_generate(avatars_data))

puts "\n📊 Résumé:"
puts "  - Avatars exportés: #{avatars_data.count}"
puts "  - Fichier: tmp/avatars_export.json"

