# Script pour vérifier les emails des utilisateurs
# À exécuter dans rails console : load 'verifier_emails_utilisateurs.rb'

puts "\n📧 Vérification des emails des utilisateurs\n"
puts "=" * 50

# Chercher les 4 utilisateurs
users_to_check = ['user', 'ja', 'driss', 'admin']

users_to_check.each do |username|
  user = User.find_by(username: username)
  
  if user
    puts "\n👤 Utilisateur: #{username}"
    puts "   Email: #{user.email}"
    puts "   ID: #{user.id}"
    puts "   Créé le: #{user.created_at}"
  else
    puts "\n❌ Utilisateur '#{username}' non trouvé"
  end
end

puts "\n" + "=" * 50
puts "\n📊 Tous les utilisateurs:\n"

User.all.each do |user|
  puts "  - #{user.username || 'sans username'} (#{user.email})"
end

puts "\n✅ Vérification terminée\n"

