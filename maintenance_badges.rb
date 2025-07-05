# Script de maintenance pour vérifier et corriger les badges
# À exécuter périodiquement (quotidiennement ou hebdomadairement)
# Les badges ne sont attribués QUE si l'utilisateur a le nombre de points requis

puts "🔧 Maintenance des badges - #{Time.current.strftime('%d/%m/%Y %H:%M')}"
puts "=" * 50
puts "Règle : Les badges ne sont attribués que si les points requis sont atteints"

# Vérifier et corriger les badges de tous les utilisateurs
puts "\n📊 Vérification des badges pour tous les utilisateurs..."
User.check_and_fix_all_badges

# Statistiques
total_users = User.count
users_with_badges = User.joins(:user_badges).distinct.count
total_badges = UserBadge.count

puts "\n📈 Statistiques :"
puts "- Utilisateurs totaux : #{total_users}"
puts "- Utilisateurs avec badges : #{users_with_badges}"
puts "- Badges attribués au total : #{total_badges}"

# Détail par type de badge
puts "\n🏆 Répartition par type de badge :"
Badge::BADGE_TYPES.each do |badge_type|
  count = UserBadge.joins(:badge).where(badges: { badge_type: badge_type }).count
  puts "- #{badge_type.capitalize} : #{count} badges"
end

# Utilisateurs sans badges avec leurs scores
users_without_badges = User.left_joins(:user_badges).where(user_badges: { id: nil })
if users_without_badges.any?
  puts "\n⚠️  Utilisateurs sans badges (scores insuffisants) :"
  users_without_badges.each do |user|
    puts "- #{user.email}"
    puts "  Competitor: #{user.competitor_score} pts (Bronze: 1000, Silver: 3000, Gold: 5000)"
    puts "  Engager: #{user.engager_score} pts (Bronze: 500, Silver: 1500, Gold: 3000)"
    puts "  Critic: #{user.critic_score} pts (Bronze: 500, Silver: 2000, Gold: 4000)"
    puts "  Challenger: #{user.challenger_score} pts (Bronze: 2500, Silver: 5000, Gold: 7000)"
  end
else
  puts "\n✅ Tous les utilisateurs ont au moins un badge !"
end

# Vérifier les badges qui pourraient être attribués
puts "\n🔍 Vérification des badges manquants :"
User.all.each do |user|
  missing_badges = []
  
  Badge.all.each do |badge|
    current_score = case badge.badge_type
                   when 'competitor' then user.competitor_score
                   when 'engager' then user.engager_score
                   when 'critic' then user.critic_score
                   when 'challenger' then user.challenger_score
                   end
    
    if current_score >= badge.points_required && !user.badges.include?(badge)
      missing_badges << "#{badge.name} (#{current_score}/#{badge.points_required})"
    end
  end
  
  if missing_badges.any?
    puts "⚠️  #{user.email} : #{missing_badges.join(', ')}"
  end
end

puts "\n✅ Maintenance terminée !"
puts "Rappel : Les badges ne sont attribués que si les points requis sont atteints." 