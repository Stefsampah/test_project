#!/usr/bin/env ruby

# Script pour sécuriser les mots de passe de l'admin
puts "🔐 Sécurisation des mots de passe de l'admin..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'admin
admin = User.find_by(email: 'admin@example.com')
if admin.nil?
  puts "❌ Admin non trouvé. Créez d'abord un utilisateur admin."
  exit 1
end

puts "👤 Admin trouvé: #{admin.email}"

# Mettre à jour le mot de passe avec une valeur sécurisée
new_password = "AdminSecure2025!"
admin.update!(password: new_password)

puts "✅ Mot de passe mis à jour pour l'admin"
puts "🔑 Nouveau mot de passe: #{new_password}"
puts "⚠️  IMPORTANT: Changez ce mot de passe après la première connexion !"

# Créer aussi un utilisateur de test avec des données réalistes
test_user = User.find_or_create_by!(email: 'test@example.com') do |user|
  user.password = 'TestSecure2025!'
  user.username = 'TestUser'
end

# Donner quelques points au user de test
test_user.update!(points: 1500)
puts "\n🧪 Utilisateur de test créé/mis à jour:"
puts "📧 Email: test@example.com"
puts "🔑 Mot de passe: TestSecure2025!"
puts "💰 Points: 1500"

puts "\n🎯 Comptes disponibles pour les tests:"
puts "👤 Admin:"
puts "   📧 admin@example.com"
puts "   🔑 #{new_password}"
puts "   💰 Points: #{admin.points || 0}"
puts "   🏆 Badges: #{admin.user_badges.count}"
puts "   🔓 Playlists premium: #{admin.user_playlist_unlocks.count}"

puts "\n🧪 Test User:"
puts "   📧 test@example.com"
puts "   🔑 TestSecure2025!"
puts "   💰 Points: #{test_user.points || 0}"

puts "\n🚀 Prêt pour les tests de production !"
puts "🌐 Connexez-vous sur votre app déployée et testez :"
puts "   - ✅ Connexion des deux comptes"
puts "   - ✅ Jeu sur les playlists premium"
puts "   - ✅ Système de badges et récompenses"
puts "   - ✅ Boutique et achats"
puts "   - ✅ Affichage des thumbnails"

puts "\n⚠️  Rappel sécurité: Changez les mots de passe avant la mise en production publique !"
