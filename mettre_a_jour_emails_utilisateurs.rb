# Script pour mettre à jour les emails des utilisateurs
# À exécuter dans rails console : load 'mettre_a_jour_emails_utilisateurs.rb'

puts "\n📧 Mise à jour des emails des utilisateurs\n"
puts "=" * 50

# Mapping des utilisateurs vers leurs nouveaux emails
mappings = {
  'Admin' => 'admin@tubenplay.com',
  'Jordan' => 'user@tubenplay.com',  # ou jordan@tubenplay.com si vous préférez
  'Driss' => 'driss@tubenplay.com',
  'Ja' => 'ja@tubenplay.com'
}

mappings.each do |username, new_email|
  user = User.find_by(username: username)
  
  if user
    old_email = user.email
    puts "\n👤 #{username}:"
    puts "   Ancien email: #{old_email}"
    puts "   Nouveau email: #{new_email}"
    
    # Mettre à jour l'email
    user.email = new_email
    
    if user.save
      puts "   ✅ Email mis à jour avec succès"
    else
      puts "   ❌ Erreur: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "\n❌ Utilisateur '#{username}' non trouvé"
  end
end

puts "\n" + "=" * 50
puts "\n✅ Mise à jour terminée\n"

# Vérifier les nouveaux emails
puts "\n📋 Vérification des emails mis à jour:\n"
User.all.each do |user|
  puts "  - #{user.username}: #{user.email}"
end

