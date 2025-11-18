# Script pour ajouter des avatars aux utilisateurs depuis des fichiers locaux
# Usage: rails runner ajouter_avatars.rb
#
# Prérequis:
# - Placez les images dans: app/assets/images/players/
# - Nommez-les: Driss.jpg, Ja.jpg, jordan.jpg (ou .png)

puts "\n📸 Ajout des avatars aux utilisateurs\n"
puts "=" * 50

# Configuration des avatars à ajouter
# Les images doivent être dans: app/assets/images/players/
AVATARS_TO_ADD = {
  'driss@tubenplay.com' => {
    name: 'Driss',
    paths: [
      'app/assets/images/players/Driss.jpg',
      'app/assets/images/players/Driss.png',
      'app/assets/images/players/driss.jpg',
      'app/assets/images/players/driss.png'
    ]
  },
  'ja@tubenplay.com' => {
    name: 'Ja',
    paths: [
      'app/assets/images/players/Ja.jpg',
      'app/assets/images/players/Ja.png',
      'app/assets/images/players/ja.jpg',
      'app/assets/images/players/ja.png'
    ]
  },
  'user@tubenplay.com' => {
    name: 'Jordan',
    paths: [
      'app/assets/images/players/jordan.jpg',
      'app/assets/images/players/Jordan.jpg',
      'app/assets/images/players/jordan.png',
      'app/assets/images/players/Jordan.png'
    ]
  }
}

AVATARS_TO_ADD.each do |email, config|
  user = User.find_by(email: email)
  
  if user.nil?
    puts "\n⚠️  Utilisateur #{email} (#{config[:name]}) non trouvé"
    next
  end
  
  puts "\n👤 #{config[:name]} (#{email}):"
  
  # Vérifier si l'utilisateur a déjà un avatar
  if user.avatar.attached?
    puts "   ⚠️  Avatar déjà présent: #{user.avatar.filename}"
    puts "   💡 Pour le remplacer, supprimez d'abord l'ancien avatar"
    next
  end
  
  # Chercher le fichier image
  image_path = nil
  config[:paths].each do |path|
    if File.exist?(path)
      image_path = path
      break
    end
  end
  
  if image_path.nil?
    puts "   ❌ Aucune image trouvée dans les chemins suivants:"
    config[:paths].each do |path|
      puts "      - #{path}"
    end
    puts "   💡 Placez l'image dans l'un de ces emplacements"
    next
  end
  
  # Attacher l'image
  begin
    file = File.open(image_path)
    user.avatar.attach(
      io: file,
      filename: File.basename(image_path),
      content_type: "image/#{File.extname(image_path)[1..-1]}"
    )
    file.close
    
    if user.avatar.attached?
      puts "   ✅ Avatar ajouté avec succès!"
      puts "   📁 Fichier: #{image_path}"
      puts "   📏 Taille: #{File.size(image_path)} bytes"
    else
      puts "   ❌ Erreur: L'avatar n'a pas pu être attaché"
    end
  rescue => e
    puts "   ❌ Erreur lors de l'ajout de l'avatar:"
    puts "      #{e.message}"
  end
end

puts "\n" + "=" * 50
puts "\n✅ Terminé!\n"

# Afficher l'état final
puts "\n📊 État final des avatars:"
User.where(email: AVATARS_TO_ADD.keys).each do |user|
  status = user.avatar.attached? ? "✅ #{user.avatar.filename}" : "❌ Aucun"
  puts "   #{user.username || user.email}: #{status}"
end

