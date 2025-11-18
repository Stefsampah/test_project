# Script pour mettre à jour les utilisateurs
# Usage: rails runner mettre_a_jour_utilisateurs.rb

puts "\n👤 Mise à jour des utilisateurs\n"
puts "=" * 50

# 1. Mettre à jour le username de user@tubenplay.com en "Jordan"
jordan = User.find_by(email: 'user@tubenplay.com')
if jordan
  old_username = jordan.username
  jordan.username = 'Jordan'
  
  if jordan.save
    puts "\n✅ Username mis à jour pour user@tubenplay.com:"
    puts "   Ancien: #{old_username || 'nil'}"
    puts "   Nouveau: #{jordan.username}"
  else
    puts "\n❌ Erreur lors de la mise à jour:"
    puts "   #{jordan.errors.full_messages.join(', ')}"
  end
else
  puts "\n⚠️  Utilisateur user@tubenplay.com non trouvé"
end

# 2. Vérifier les avatars existants
puts "\n📸 État actuel des avatars:"
puts "=" * 50

users_to_check = [
  { email: 'admin@tubenplay.com', name: 'Admin' },
  { email: 'user@tubenplay.com', name: 'Jordan' },
  { email: 'driss@tubenplay.com', name: 'Driss' },
  { email: 'ja@tubenplay.com', name: 'Ja' }
]

users_to_check.each do |info|
  user = User.find_by(email: info[:email])
  if user
    has_avatar = user.avatar.attached?
    puts "\n👤 #{info[:name]} (#{info[:email]}):"
    puts "   Username: #{user.username || 'non défini'}"
    puts "   Avatar: #{has_avatar ? '✅ OUI' : '❌ NON'}"
    if has_avatar
      puts "   Fichier: #{user.avatar.filename}"
    end
  else
    puts "\n⚠️  #{info[:name]} (#{info[:email]}) non trouvé"
  end
end

puts "\n" + "=" * 50
puts "\n✅ Vérification terminée\n"

puts "\n💡 Pour ajouter des avatars pour Jordan, Driss et Ja:"
puts "   1. Placez les images dans: app/assets/images/players/"
puts "   2. Nommez-les: jordan.jpg, Driss.jpg et Ja.jpg"
puts "   3. Exécutez: rails runner ajouter_avatars.rb"

