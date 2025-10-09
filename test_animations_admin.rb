#!/usr/bin/env ruby
# 🎉 Script Admin pour tester les animations de récompenses et badges
# Usage: rails runner test_animations_admin.rb

puts "🎉 Script Admin - Test des Animations Tube'NPlay"
puts "=" * 50

# Vérifier si on est en environnement Rails
unless defined?(Rails)
  puts "❌ Ce script doit être exécuté avec: rails runner test_animations_admin.rb"
  exit 1
end

# Trouver un utilisateur admin ou créer un utilisateur de test
user = User.find_by(email: 'admin@example.com') || User.first

unless user
  puts "❌ Aucun utilisateur trouvé. Créez d'abord un utilisateur."
  exit 1
end

puts "👤 Utilisateur de test: #{user.email}"

# Fonction pour tester les animations de récompenses
def test_reward_animations(user)
  puts "\n🎉 Test des animations de récompenses"
  puts "-" * 30
  
  reward_types = ['challenge', 'exclusif', 'premium', 'ultime']
  
  reward_types.each do |type|
    puts "📦 Test animation #{type}..."
    
    # Créer une récompense de test
    reward = Reward.create!(
      user: user,
      reward_type: type,
      badge_type: 'unified',
      quantity_required: get_quantity_for_type(type),
      reward_description: "Récompense #{type.humanize} de test",
      content_type: "test_#{type}",
      unlocked: false
    )
    
    # Débloquer la récompense (déclenche l'animation)
    reward.update!(unlocked: true, unlocked_at: Time.current)
    
    puts "✅ Récompense #{type} débloquée et animation déclenchée"
    sleep(1) # Pause pour voir l'animation
  end
end

# Fonction pour tester les animations de badges
def test_badge_animations(user)
  puts "\n🏆 Test des animations de badges"
  puts "-" * 30
  
  badge_types = ['competitor', 'engager', 'critic', 'challenger']
  levels = ['bronze', 'silver', 'gold']
  
  badge_types.each_with_index do |type, index|
    level = levels[index % levels.length]
    
    puts "🏅 Test animation badge #{type} #{level}..."
    
    # Trouver ou créer le badge
    badge = Badge.find_or_create_by!(
      name: "#{level.capitalize} #{type.capitalize}",
      badge_type: type,
      level: level,
      points_required: get_points_for_level(level),
      reward_type: 'standard'
    )
    
    # Créer le UserBadge (déclenche l'animation)
    user_badge = UserBadge.create!(
      user: user,
      badge: badge,
      earned_at: Time.current
    )
    
    puts "✅ Badge #{type} #{level} débloqué et animation déclenchée"
    sleep(1) # Pause pour voir l'animation
  end
end

# Fonction pour vérifier les données en cache
def check_cached_animations(user)
  puts "\n💾 Vérification des données en cache"
  puts "-" * 30
  
  # Vérifier les récompenses en cache
  reward_cache_keys = Rails.cache.instance_variable_get(:@data)&.keys&.grep(/reward_animation_#{user.id}_/) || []
  puts "📦 Récompenses en cache: #{reward_cache_keys.count}"
  
  reward_cache_keys.each do |key|
    data = Rails.cache.read(key)
    puts "  - #{key}: #{data[:title]} (#{data[:type]})"
  end
  
  # Vérifier les badges en cache
  badge_cache_keys = Rails.cache.instance_variable_get(:@data)&.keys&.grep(/badge_animation_#{user.id}_/) || []
  puts "🏆 Badges en cache: #{badge_cache_keys.count}"
  
  badge_cache_keys.each do |key|
    data = Rails.cache.read(key)
    puts "  - #{key}: #{data[:title]} (#{data[:badge_type]})"
  end
end

# Fonction pour nettoyer les données de test
def cleanup_test_data(user)
  puts "\n🧹 Nettoyage des données de test"
  puts "-" * 30
  
  # Supprimer les récompenses de test
  test_rewards = user.rewards.where("reward_description LIKE ?", "%de test%")
  puts "🗑️ Suppression de #{test_rewards.count} récompenses de test"
  test_rewards.destroy_all
  
  # Supprimer les UserBadges de test
  test_badges = user.user_badges.joins(:badge).where("badges.name LIKE ?", "%test%")
  puts "🗑️ Suppression de #{test_badges.count} badges de test"
  test_badges.destroy_all
  
  # Nettoyer le cache
  Rails.cache.clear
  puts "🗑️ Cache nettoyé"
end

# Fonctions utilitaires
def get_quantity_for_type(type)
  case type
  when 'challenge' then 3
  when 'exclusif' then 6
  when 'premium' then 9
  when 'ultime' then 12
  else 3
  end
end

def get_points_for_level(level)
  case level
  when 'bronze' then 500
  when 'silver' then 1000
  when 'gold' then 2000
  else 500
  end
end

# Menu principal
def show_menu
  puts "\n📋 Menu des tests:"
  puts "1. Tester les animations de récompenses"
  puts "2. Tester les animations de badges"
  puts "3. Vérifier les données en cache"
  puts "4. Nettoyer les données de test"
  puts "5. Test complet (tout)"
  puts "0. Quitter"
  print "\nChoisissez une option (0-5): "
end

# Boucle principale
loop do
  show_menu
  choice = gets.chomp.to_i
  
  case choice
  when 1
    test_reward_animations(user)
  when 2
    test_badge_animations(user)
  when 3
    check_cached_animations(user)
  when 4
    cleanup_test_data(user)
  when 5
    puts "\n🚀 Test complet en cours..."
    test_reward_animations(user)
    test_badge_animations(user)
    check_cached_animations(user)
    puts "\n✅ Test complet terminé!"
  when 0
    puts "\n👋 Au revoir!"
    break
  else
    puts "❌ Option invalide. Veuillez choisir entre 0 et 5."
  end
  
  puts "\n" + "=" * 50
end

puts "\n🎉 Script terminé!"
puts "💡 Pour voir les animations en action, ouvrez l'application dans le navigateur"
puts "🔗 URL: http://localhost:3000"
puts "📱 Page des animations: http://localhost:3000/reward_animations_demo"
