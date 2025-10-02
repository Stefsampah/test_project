namespace :admin do
  desc "Donner temporairement tous les badges à l'admin pour tests"
  task give_all_badges: :environment do
    puts "🎯 Attribution de tous les badges à l'admin pour tests"
    puts "=" * 60
    
    # Trouver l'utilisateur admin
    admin = User.find_by(email: 'admin@example.com')
    
    if admin.nil?
      puts "❌ Utilisateur admin non trouvé. Créons-en un..."
      admin = User.create!(
        email: 'admin@example.com',
        password: '123456',
        admin: true,
        username: 'admin_test'
      )
      puts "✅ Admin créé avec succès"
    end
    
    puts "\n👤 Admin: #{admin.email}"
    puts "🏆 Badges actuels: #{admin.user_badges.count}"
    puts "💰 Points actuels: #{admin.total_points}"
    
    # Donner des points élevés à l'admin pour déclencher les badges
    admin.update!(points: 5000)  # Points achetés élevés
    puts "💰 Points élevés assignés: #{admin.total_points}"
    
    # Supprimer les badges existants pour repartir à zéro
    admin.user_badges.destroy_all
    puts "🧹 Badges existants supprimés"
    
    # Trouver tous les badges disponibles
    all_badges = Badge.all
    
    if all_badges.empty?
      puts "❌ Aucun badge trouvé dans la base de données"
      puts "💡 Créons les badges de base..."
      
      # Créer les badges manquants avec la structure correcte
      badge_data = [
        # Badges Competitor 
        { name: 'Competitor Bronze', badge_type: 'competitor', level: 'bronze', points_required: 50, condition_1_type: 'total_points', condition_1_value: 50 },
        { name: 'Competitor Silver', badge_type: 'competitor', level: 'silver', points_required: 150, condition_1_type: 'total_points', condition_1_value: 150 },
        { name: 'Competitor Gold', badge_type: 'competitor', level: 'gold', points_required: 300, condition_1_type: 'total_points', condition_1_value: 300 },
        
        # Badges Engager 
        { name: 'Engager Bronze', badge_type: 'engager', level: 'bronze', points_required: 75, condition_1_type: 'listening_points', condition_1_value: 75 },
        { name: 'Engager Silver', badge_type: 'engager', level: 'silver', points_required: 200, condition_1_type: 'listening_points', condition_1_value: 200 },
        { name: 'Engager Gold', badge_type: 'engager', level: 'gold', points_required: 400, condition_1_type: 'listening_points', condition_1_value: 400 },
        
        # Badges Critic 
        { name: 'Critic Bronze', badge_type: 'critic', level: 'bronze', points_required: 100, condition_1_type: 'critical_opinions', condition_1_value: 100 },
        { name: 'Critic Silver', badge_type: 'critic', level: 'silver', points_required: 250, condition_1_type: 'critical_opinions', condition_1_value: 250 },
        { name: 'Critic Gold', badge_type: 'critic', level: 'gold', points_required: 500, condition_1_type: 'critical_opinions', condition_1_value: 500 },
        
        # Badges Challenger 
        { name: 'Challenger Bronze', badge_type: 'challenger', level: 'bronze', points_required: 200, condition_1_type: 'total_points', condition_1_value: 200 },
        { name: 'Challenger Silver', badge_type: 'challenger', level: 'silver', points_required: 400, condition_1_type: 'total_points', condition_1_value: 400 },
        { name: 'Challenger Gold', badge_type: 'challenger', level: 'gold', points_required: 700, condition_1_type: 'total_points', condition_1_value: 700 }
      ]
      
      badge_data.each do |badge_attr|
        Badge.create!(
          name: badge_attr[:name],
          badge_type: badge_attr[:badge_type], 
          level: badge_attr[:level],
          points_required: badge_attr[:points_required],
          condition_1_type: badge_attr[:condition_1_type],
          condition_1_value: badge_attr[:condition_1_value]
        )
        puts "  ✅ Badge créé: #{badge_attr[:name]}"
      end
      
      all_badges = Badge.all
    end
    
    puts "\n🎖️ Attribution de #{all_badges.count} badges à l'admin..."
    
    # Attribuer tous les badges à l'admin
    all_badges.each do |badge|
      unless admin.badges.include?(badge)
        admin.user_badges.create!(
          badge: badge,
          earned_at: Time.current,
          points_at_earned: admin.total_points || 1000
        )
        puts "  ✅ Attribué: #{badge.name} (#{badge.level})"
      end
    end
    
    # Vérifier le résultat
    final_badge_count = admin.user_badges.count
    puts "\n🎉 Attribution terminée !"
    puts "📊 Résultat:"
    puts "   - Badges totaux: #{final_badge_count}"
    puts "   - Récompenses éligibles: #{admin.rewards.count}"
    
    # Créer automatiquement les récompenses
    puts "\n🏆 Génération des récompenses..."
    Reward.check_and_create_rewards_for_user(admin)
    rewards_count = admin.rewards.unlocked.count
    puts "   ✅ #{rewards_count} récompenses débloquées automatiquement"
    
    puts "\n🌟 Admin prêt pour les tests !"
    puts "🔗 URLs pour tester:"
    puts "   - Profil: http://localhost:3000/profile"
    puts "   - Récompenses: http://localhost:3000/my_rewards"
    puts "   - Toutes récompenses: http://localhost:3000/all_rewards"
    puts "   - NFTs: http://localhost:3000/reward_details?content_type=didi_b_nft"
    puts "\n💡 Connexion admin: admin@example.com / 123456"
  end
  
  desc "Supprimer tous les badges de l'admin (reset)"
  task reset_badges: :environment do
    admin = User.find_by(email: 'admin@example.com')
    if admin
      admin.user_badges.destroy_all
      admin.rewards.destroy_all
      puts "🧹 Badges et récompenses de l'admin supprimés"
    else
      puts "❌ Admin non trouvé"
    end
  end
end
