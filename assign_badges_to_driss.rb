# Script pour forcer l'attribution des badges à Driss
# À exécuter dans Rails console

puts "Attribution des badges à Driss..."

driss = User.find_by(email: 'driss@example.com')
if driss
  puts "Utilisateur Driss trouvé : #{driss.email}"
  
  # Afficher les scores actuels
  puts "\nScores actuels de Driss :"
  puts "- Competitor Score: #{driss.competitor_score}"
  puts "- Engager Score: #{driss.engager_score}"
  puts "- Critic Score: #{driss.critic_score}"
  puts "- Challenger Score: #{driss.challenger_score}"
  
  # Supprimer les badges existants pour éviter les doublons
  driss.user_badges.destroy_all
  puts "\nBadges existants supprimés."
  
  # Forcer l'attribution des badges
  puts "\nAttribution des nouveaux badges..."
  BadgeService.assign_badges(driss)
  
  # Vérifier les badges attribués
  puts "\nBadges attribués à Driss :"
  driss.user_badges.includes(:badge).each do |user_badge|
    badge = user_badge.badge
    puts "- #{badge.name} (#{badge.badge_type} #{badge.level}) - #{badge.points_required} pts requis"
  end
  
  puts "\nAttribution terminée !"
  puts "Driss peut maintenant voir ses badges sur /my_badges"
else
  puts "✗ Utilisateur Driss non trouvé"
end 