#!/usr/bin/env ruby

require_relative 'config/environment'

puts "🏆 ATTRIBUTION DE BADGES À L'UTILISATEUR DE TEST"
puts "=================================================="

# Trouver l'utilisateur de test
user = User.find_by(email: 'test_audio_comments@example.com')

if user.nil?
  puts "❌ Utilisateur test_audio_comments@example.com non trouvé"
  exit 1
end

puts "👤 Utilisateur trouvé: #{user.email}"
puts "📊 Badges actuels: #{user.user_badges.count}"

# Créer 6 badges différents pour l'utilisateur
badge_types = ['competitor', 'engager', 'critic', 'challenger', 'competitor', 'engager']
levels = ['bronze', 'silver', 'gold', 'bronze', 'silver', 'gold']

badge_types.each_with_index do |badge_type, index|
  level = levels[index]
  
  # Créer ou trouver le badge
  badge = Badge.find_or_create_by!(badge_type: badge_type, level: level) do |b|
    b.name = "#{badge_type.humanize} #{level.humanize}"
    b.description = "Description pour #{badge_type} #{level}"
    b.points_required = case level
                       when 'bronze' then 500
                       when 'silver' then 1000
                       when 'gold' then 2000
                       else 500
                       end
  end
  
  # Attribuer le badge à l'utilisateur
  user_badge = user.user_badges.find_or_initialize_by(badge: badge)
  if user_badge.new_record?
    user_badge.earned_at = Time.current
    user_badge.points_at_earned = user.total_points || 0
    user_badge.save!
    puts "✅ Badge attribué: #{badge.name}"
  else
    puts "ℹ️  Badge déjà possédé: #{badge.name}"
  end
end

puts "\n📊 RÉSULTAT FINAL"
puts "=================="
puts "👤 Utilisateur: #{user.email}"
puts "🏆 Total badges: #{user.user_badges.count}"
puts "🎯 Condition pour récompense Exclusif: #{user.user_badges.count >= 6 ? '✅ RÉUSSIE' : '❌ ÉCHEC'}"

puts "\n🔗 POUR TESTER:"
puts "1. Connectez-vous avec: #{user.email}"
puts "2. Allez sur /rewards"
puts "3. Cliquez sur 'Afficher le contenu →' pour la récompense Exclusif"
puts "4. Le bouton '🎧 Écouter les commentaires' devrait maintenant apparaître"
puts "5. Cliquez dessus pour tester la modale YouTube"

puts "\n🎉 Script terminé avec succès !"
