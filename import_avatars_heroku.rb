#!/usr/bin/env ruby
# Script pour importer les avatars des utilisateurs sur Heroku

require 'json'
require 'base64'

puts "📥 Import des avatars des utilisateurs sur Heroku..."
puts "=" * 80

# Lire le fichier JSON
avatars_data = JSON.parse(File.read('tmp/avatars_export.json'))

avatars_data.each do |avatar_data|
  user = User.find_by(email: avatar_data['email'])
  
  if user.nil?
    puts "⚠️  Utilisateur #{avatar_data['email']} non trouvé"
    next
  end
  
  # Décoder le base64
  begin
    avatar_binary = Base64.strict_decode64(avatar_data['data'])
    
    # Créer un fichier temporaire
    require 'tempfile'
    temp_file = Tempfile.new([avatar_data['filename'], File.extname(avatar_data['filename'])])
    temp_file.binmode
    temp_file.write(avatar_binary)
    temp_file.rewind
    
    # Attacher l'avatar
    user.avatar.attach(
      io: temp_file,
      filename: avatar_data['filename'],
      content_type: avatar_data['content_type']
    )
    
    temp_file.close
    temp_file.unlink
    
    if user.avatar.attached?
      puts "✅ #{user.email}: Avatar importé (#{avatar_data['filename']})"
    else
      puts "❌ #{user.email}: Erreur lors de l'import"
    end
  rescue => e
    puts "❌ Erreur pour #{user.email}: #{e.message}"
  end
end

puts "\n📊 Résumé final:"
User.all.each do |user|
  status = user.avatar.attached? ? "✅ #{user.avatar.filename}" : "❌ Pas d'avatar"
  puts "  - #{user.email}: #{status}"
end

