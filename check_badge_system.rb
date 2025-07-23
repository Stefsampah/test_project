#!/usr/bin/env ruby
# Script pour vérifier l'état actuel du système de badges

puts "🔍 VÉRIFICATION DE L'ÉTAT ACTUEL DU SYSTÈME DE BADGES"
puts "=" * 60

# Charger l'environnement Rails
require_relative 'config/environment'

# 1. Vérifier le badge Bronze Engager
puts "\n🎯 1. ANALYSE DU BADGE BRONZE ENGAGER"
bronze_engager = Badge.find_by(badge_type: 'engager', level: 'bronze')

if bronze_engager
  puts "✅ Badge trouvé: #{bronze_engager.name}"
  puts "📊 Conditions actuelles:"
  puts "   - condition_1_type: #{bronze_engager.condition_1_type || 'NIL'}"
  puts "   - condition_1_value: #{bronze_engager.condition_1_value || 'NIL'}"
  puts "   - condition_2_type: #{bronze_engager.condition_2_type || 'NIL'}"
  puts "   - condition_2_value: #{bronze_engager.condition_2_value || 'NIL'}"
  puts "   - condition_3_type: #{bronze_engager.condition_3_type || 'NIL'}"
  puts "   - condition_3_value: #{bronze_engager.condition_3_value || 'NIL'}"
  puts "   - points_required: #{bronze_engager.points_required}"
  puts "   - reward_description: #{bronze_engager.reward_description}"
else
  puts "❌ Badge Bronze Engager non trouvé"
end

# 2. Vérifier TestUser
puts "\n👤 2. ANALYSE DE TESTUSER"
test_user = User.find_by(email: 'test@example.com')

if test_user
  puts "✅ Utilisateur trouvé: #{test_user.email}"
  puts "📊 Statistiques actuelles:"
  puts "   - Total points: #{test_user.total_points}"
  puts "   - Games count: #{test_user.games.count}"
  puts "   - Unique playlists: #{test_user.unique_playlists_played_count}"
  puts "   - Win ratio: #{test_user.win_ratio}%"
  puts "   - Top 3 count: #{test_user.top_3_finishes_count}"
  puts "   - Consecutive wins: #{test_user.consecutive_wins_count}"
  
  # Vérifier les badges de TestUser
  user_badges = test_user.user_badges.includes(:badge)
  puts "\n🏆 Badges obtenus par TestUser:"
  user_badges.each do |user_badge|
    badge = user_badge.badge
    puts "   - #{badge.name} (obtenu le #{user_badge.earned_at&.strftime('%d/%m/%Y')})"
    puts "     Points au moment de l'obtention: #{user_badge.points_at_earned}"
  end
  
  # Vérifier si TestUser devrait avoir le Bronze Engager
  if bronze_engager
    puts "\n🎯 VÉRIFICATION DES CONDITIONS POUR BRONZE ENGAGER:"
    
    # Vérifier chaque condition
    conditions_met = []
    
    if bronze_engager.condition_1_type.present?
      actual_value = case bronze_engager.condition_1_type
                     when 'points_earned' then test_user.total_points
                     when 'games_played' then test_user.games.count
                     when 'win_ratio' then test_user.win_ratio
                     when 'top_3_count' then test_user.top_3_finishes_count
                     when 'consecutive_wins' then test_user.consecutive_wins_count
                     when 'unique_playlists' then test_user.unique_playlists_played_count
                     else 0
                     end
      
      condition_met = actual_value >= bronze_engager.condition_1_value
      conditions_met << condition_met
      puts "   - #{bronze_engager.condition_1_type}: #{actual_value}/#{bronze_engager.condition_1_value} #{condition_met ? '✅' : '❌'}"
    end
    
    if bronze_engager.condition_2_type.present?
      actual_value = case bronze_engager.condition_2_type
                     when 'points_earned' then test_user.total_points
                     when 'games_played' then test_user.games.count
                     when 'win_ratio' then test_user.win_ratio
                     when 'top_3_count' then test_user.top_3_finishes_count
                     when 'consecutive_wins' then test_user.consecutive_wins_count
                     when 'unique_playlists' then test_user.unique_playlists_played_count
                     else 0
                     end
      
      condition_met = actual_value >= bronze_engager.condition_2_value
      conditions_met << condition_met
      puts "   - #{bronze_engager.condition_2_type}: #{actual_value}/#{bronze_engager.condition_2_value} #{condition_met ? '✅' : '❌'}"
    end
    
    if bronze_engager.condition_3_type.present?
      actual_value = case bronze_engager.condition_3_type
                     when 'points_earned' then test_user.total_points
                     when 'games_played' then test_user.games.count
                     when 'win_ratio' then test_user.win_ratio
                     when 'top_3_count' then test_user.top_3_finishes_count
                     when 'consecutive_wins' then test_user.consecutive_wins_count
                     when 'unique_playlists' then test_user.unique_playlists_played_count
                     else 0
                     end
      
      condition_met = actual_value >= bronze_engager.condition_3_value
      conditions_met << condition_met
      puts "   - #{bronze_engager.condition_3_type}: #{actual_value}/#{bronze_engager.condition_3_value} #{condition_met ? '✅' : '❌'}"
    end
    
    # Vérifier les points requis (fallback)
    points_met = test_user.total_points >= bronze_engager.points_required
    puts "   - points_required: #{test_user.total_points}/#{bronze_engager.points_required} #{points_met ? '✅' : '❌'}"
    
    # Résultat final
    all_conditions_met = conditions_met.all? && points_met
    puts "\n🎯 RÉSULTAT: #{all_conditions_met ? '✅ TestUser devrait avoir le badge' : '❌ TestUser ne devrait PAS avoir le badge'}"
    
    # Vérifier si TestUser a déjà le badge
    has_badge = test_user.user_badges.exists?(badge: bronze_engager)
    puts "🏆 TestUser a le badge: #{has_badge ? '✅ OUI' : '❌ NON'}"
    
    if has_badge && !all_conditions_met
      puts "⚠️  PROBLÈME: TestUser a le badge mais ne remplit pas les conditions !"
    elsif !has_badge && all_conditions_met
      puts "⚠️  PROBLÈME: TestUser devrait avoir le badge mais ne l'a pas !"
    end
  end
else
  puts "❌ TestUser non trouvé"
end

# 3. Vérifier tous les badges
puts "\n🏆 3. ANALYSE DE TOUS LES BADGES"
Badge.all.each do |badge|
  puts "\n📊 #{badge.name}:"
  puts "   - Type: #{badge.badge_type}"
  puts "   - Level: #{badge.level}"
  puts "   - Points required: #{badge.points_required}"
  puts "   - Conditions: #{badge.conditions_description || 'Aucune condition multiple'}"
end

puts "\n" + "=" * 60
puts "🔍 VÉRIFICATION TERMINÉE" 