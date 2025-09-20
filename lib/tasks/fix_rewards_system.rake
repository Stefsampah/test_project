namespace :rewards do
  desc "Fix the rewards system by cleaning corrupted and excessive rewards"
  task fix_system: :environment do
    puts "🔧 CORRECTION DU SYSTÈME DE RÉCOMPENSES"
    puts "=" * 50
    
    # 1. Nettoyer les récompenses corrompues (sans content_type)
    puts "\n1. 🧹 Nettoyage des récompenses corrompues..."
    corrupted_rewards = Reward.where(content_type: nil)
    puts "   Récompenses corrompues trouvées: #{corrupted_rewards.count}"
    
    if corrupted_rewards.any?
      corrupted_rewards.destroy_all
      puts "   ✅ Récompenses corrompues supprimées"
    else
      puts "   ✅ Aucune récompense corrompue trouvée"
    end
    
    # 2. Nettoyer les récompenses en excès
    puts "\n2. 🧹 Nettoyage des récompenses en excès..."
    
    User.all.each do |user|
      badge_count = user.user_badges.count
      puts "\n   👤 Utilisateur: #{user.email} (#{badge_count} badges)"
      
      # Supprimer les récompenses en excès selon les règles
      rewards_to_keep = case badge_count
      when 0..2
        [] # Aucune récompense
      when 3..5
        user.rewards.challenge.limit(1) # 1 récompense challenge max
      when 6..8
        user.rewards.challenge.limit(1) + user.rewards.exclusif.limit(1) # 1 de chaque
      when 9..11
        user.rewards.challenge.limit(1) + user.rewards.exclusif.limit(1) + user.rewards.premium.limit(1)
      else
        user.rewards.challenge.limit(1) + user.rewards.exclusif.limit(1) + user.rewards.premium.limit(1) + user.rewards.ultime.limit(1)
      end
      
      # Supprimer les récompenses en excès
      rewards_to_delete = user.rewards - rewards_to_keep
      if rewards_to_delete.any?
        puts "     Suppression de #{rewards_to_delete.count} récompenses en excès"
        rewards_to_delete.each do |reward|
          puts "       - #{reward.reward_type} (#{reward.content_type})"
        end
        rewards_to_delete.each(&:destroy)
      else
        puts "     ✅ Aucune récompense en excès"
      end
    end
    
    # 3. Vérifier et corriger les récompenses débloquées incorrectement
    puts "\n3. 🔍 Vérification des récompenses débloquées..."
    
    User.all.each do |user|
      badge_count = user.user_badges.count
      
      # Vérifier les récompenses challenge (3+ badges requis)
      if badge_count < 3
        user.rewards.challenge.update_all(unlocked: false, unlocked_at: nil)
        puts "   👤 #{user.email}: Récompenses challenge verrouillées (#{badge_count} < 3 badges)"
      end
      
      # Vérifier les récompenses exclusif (6+ badges requis)
      if badge_count < 6
        user.rewards.exclusif.update_all(unlocked: false, unlocked_at: nil)
        puts "   👤 #{user.email}: Récompenses exclusif verrouillées (#{badge_count} < 6 badges)"
      end
      
      # Vérifier les récompenses premium (9+ badges requis)
      if badge_count < 9
        user.rewards.premium.update_all(unlocked: false, unlocked_at: nil)
        puts "   👤 #{user.email}: Récompenses premium verrouillées (#{badge_count} < 9 badges)"
      end
      
      # Vérifier les récompenses ultime (12+ badges requis)
      if badge_count < 12
        user.rewards.ultime.update_all(unlocked: false, unlocked_at: nil)
        puts "   👤 #{user.email}: Récompenses ultime verrouillées (#{badge_count} < 12 badges)"
      end
    end
    
    # 4. Créer les récompenses manquantes selon les règles
    puts "\n4. 🎁 Création des récompenses manquantes..."
    
    User.all.each do |user|
      badge_count = user.user_badges.count
      
      # Créer récompense challenge si 3+ badges et pas de récompense challenge
      if badge_count >= 3 && !user.rewards.challenge.exists?
        Reward.check_and_create_rewards_for_user(user)
        puts "   👤 #{user.email}: Récompense challenge créée"
      end
      
      # Créer récompense exclusif si 6+ badges et pas de récompense exclusif
      if badge_count >= 6 && !user.rewards.exclusif.exists?
        Reward.check_and_create_rewards_for_user(user)
        puts "   👤 #{user.email}: Récompense exclusif créée"
      end
      
      # Créer récompense premium si 9+ badges et pas de récompense premium
      if badge_count >= 9 && !user.rewards.premium.exists?
        Reward.check_and_create_rewards_for_user(user)
        puts "   👤 #{user.email}: Récompense premium créée"
      end
      
      # Créer récompense ultime si 12+ badges et pas de récompense ultime
      if badge_count >= 12 && !user.rewards.ultime.exists?
        Reward.check_and_create_rewards_for_user(user)
        puts "   👤 #{user.email}: Récompense ultime créée"
      end
    end
    
    puts "\n✅ CORRECTION TERMINÉE"
    puts "=" * 50
    
    # 5. Rapport final
    puts "\n📊 RAPPORT FINAL:"
    User.all.each do |user|
      badge_count = user.user_badges.count
      total_rewards = user.rewards.count
      unlocked_rewards = user.rewards.unlocked.count
      
      puts "👤 #{user.email}:"
      puts "   Badges: #{badge_count}"
      puts "   Récompenses totales: #{total_rewards}"
      puts "   Récompenses débloquées: #{unlocked_rewards}"
      puts "   Points totaux: #{user.total_points}"
    end
  end
  
  desc "Test the corrected rewards system"
  task test_system: :environment do
    puts "🧪 TEST DU SYSTÈME CORRIGÉ"
    puts "=" * 50
    
    User.all.each do |user|
      puts "\n👤 #{user.email}:"
      puts "   Points achetés: #{user.purchased_points}"
      puts "   Points de jeu: #{user.game_points}"
      puts "   Total points: #{user.total_points}"
      puts "   Badges: #{user.user_badges.count}"
      puts "   Récompenses: #{user.rewards.count}"
      puts "   Récompenses débloquées: #{user.rewards.unlocked.count}"
      
      # Vérifier la cohérence
      badge_count = user.user_badges.count
      expected_rewards = case badge_count
      when 0..2 then 0
      when 3..5 then 1
      when 6..8 then 2
      when 9..11 then 3
      else 4
      end
      
      if user.rewards.count == expected_rewards
        puts "   ✅ Cohérence OK"
      else
        puts "   ❌ Incohérence détectée (attendu: #{expected_rewards}, trouvé: #{user.rewards.count})"
      end
    end
  end
end
