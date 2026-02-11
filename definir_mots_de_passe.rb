# Script pour définir les mots de passe des utilisateurs
# Usage: PASSWORDS_ADMIN=xxx PASSWORDS_USER=xxx rails runner definir_mots_de_passe.rb
# Ne jamais commettre de mots de passe en clair.

puts "🔐 Définition des mots de passe pour les utilisateurs..."

PASSWORDS = {
  'admin@tubenplay.com' => ENV['PASSWORDS_ADMIN'],
  'user@tubenplay.com' => ENV['PASSWORDS_USER'],
  'driss@tubenplay.com' => ENV['PASSWORDS_DRISS'],
  'ja@tubenplay.com' => ENV['PASSWORDS_JA']
}.compact

if PASSWORDS.empty?
  puts "⚠️ Définir les variables: PASSWORDS_ADMIN, PASSWORDS_USER, PASSWORDS_DRISS, PASSWORDS_JA"
  exit 1
end

PASSWORDS.each do |email, password|
  user = User.find_by(email: email)
  if user
    user.password = password
    user.password_confirmation = password
    if user.save
      puts "✅ Mot de passe défini pour #{email} (#{user.username || 'sans nom'})"
    else
      puts "❌ Erreur pour #{email}: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "⚠️  Utilisateur #{email} non trouvé"
  end
end

puts "\n✅ Terminé !"
