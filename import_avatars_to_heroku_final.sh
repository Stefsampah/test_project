#!/bin/bash
# Script pour uploader et importer les avatars sur Heroku (version finale)

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des avatars sur Heroku..."

# Vérifier que le fichier existe
if [ ! -f "tmp/avatars_export.json" ]; then
  echo "❌ Erreur: tmp/avatars_export.json n'existe pas"
  exit 1
fi

# Créer un script bash complet qui sera exécuté sur Heroku
heroku run bash -a $APP_NAME <<HEROKU_EOF
# Créer le répertoire tmp
mkdir -p tmp

# Décoder le fichier JSON
base64 -d > tmp/avatars_export.json <<'AVATARS_B64'
$(base64 -i tmp/avatars_export.json)
AVATARS_B64

# Créer le script Ruby
cat > import_avatars_heroku.rb <<'RUBY_EOF'
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
RUBY_EOF

# Exécuter le script Ruby
rails runner import_avatars_heroku.rb
HEROKU_EOF

echo "✅ Import terminé !"
