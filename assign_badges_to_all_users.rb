# Script pour attribuer les badges à tous les utilisateurs existants
# À exécuter dans Rails console
# Les badges ne sont attribués QUE si l'utilisateur a le nombre de points requis

puts "Attribution des badges à tous les utilisateurs (si points requis atteints)..."

User.all.each do |user|
  puts "\n=== Traitement de #{user.email} ==="
  
  # Afficher les scores actuels
  puts "Scores actuels :"
  puts "- Competitor Score: #{user.competitor_score}"
  puts "- Engager Score: #{user.engager_score}"
  puts "- Critic Score: #{user.critic_score}"
  puts "- Challenger Score: #{user.challenger_score}"
  
  # Vérifier les seuils requis
  puts "\nSeuils requis pour les badges :"
  Badge.all.group_by(&:badge_type).each do |badge_type, badges|
    puts "#{badge_type.capitalize} :"
    badges.sort_by(&:points_required).each do |badge|
      current_score = case badge_type
                     when 'competitor' then user.competitor_score
                     when 'engager' then user.engager_score
                     when 'critic' then user.critic_score
                     when 'challenger' then user.challenger_score
                     end
      
      status = current_score >= badge.points_required ? "✅" : "❌"
      puts "  #{status} #{badge.name} : #{current_score}/#{badge.points_required} pts"
    end
  end
  
  # Supprimer les badges existants pour éviter les doublons
  existing_badges_count = user.user_badges.count
  if existing_badges_count > 0
    user.user_badges.destroy_all
    puts "\n#{existing_badges_count} badges existants supprimés."
  end
  
  # Forcer l'attribution des badges (seulement si points requis)
  puts "Attribution des nouveaux badges..."
  BadgeService.assign_badges(user)
  
  # Vérifier les badges attribués
  badges_count = user.user_badges.count
  puts "Badges attribués : #{badges_count}"
  
  if badges_count > 0
    user.user_badges.includes(:badge).each do |user_badge|
      badge = user_badge.badge
      puts "  ✅ #{badge.name} (#{badge.badge_type} #{badge.level}) - #{badge.points_required} pts requis"
    end
  else
    puts "  ❌ Aucun badge attribué (scores insuffisants pour tous les seuils)"
  end
  
  puts "---"
end

puts "\n✅ Attribution terminée pour tous les utilisateurs !"
puts "Rappel : Les badges ne sont attribués que si les points requis sont atteints."
puts "Tous les utilisateurs peuvent maintenant voir leurs badges sur /my_badges" 