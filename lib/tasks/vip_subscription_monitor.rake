# Tâche pour vérifier et gérer les abonnements VIP expirés
namespace :subscription do
  desc "Vérifier les abonnements VIP expirés et envoyer des notifications"
  task check_expired: :environment do
    puts "📋 Vérification des abonnements VIP expirés..."
    
    # Trouver les abonnements expirés
    expired_users = User.where(vip_subscription: true)
                        .where('vip_expires_at < ?', Time.current)
    
    expired_count = expired_users.count
    
    if expired_count > 0
      puts "🔔 #{expired_count} abonnement(s) VIP expiré(s) trouvé(s)"
      
      expired_users.each do |user|
        puts "   📧 #{user.email}: Expiré le #{user.vip_expires_at.strftime('%d/%m/%Y')}"
        
        # Ici on pourrait envoyer un email de notification
        # UserMailer.vip_expired_notification(user).deliver_now
        
        # Désactiver temporairement l'abonnement VIP
        user.update!(vip_subscription: false)
        
        puts "   ✅ Abonnement VIP désactivé pour #{user.email}"
      end
    else
      puts "✅ Tous les abonnements VIP sont actifs"
    end
    
    # Vérifier ceux qui expirent dans les 3 prochains jours
    expiring_soon = User.where(vip_subscription: true)
                       .where('vip_expires_at BETWEEN ? AND ?', Time.current, 3.days.from_now)
    
    expiring_soon.each do |user|
      puts "⚠️  #{user.email}: Expire le #{user.vip_expires_at.strftime('%d/%m/%Y')}"
      # Ici on pourrait envoyer une notification de rappel
      # UserMailer.vip_expiring_reminder(user).deliver_now
    end
    
    puts "🎯 Vérification terminée !"
  end
  
  desc "Simuler un abonnement VIP (pour les tests)"
  task simulate: :environment do
    puts "🧪 Simulation d'un abonnement VIP..."
    
    # Trouver un utilisateur test
    test_user = User.first
    if test_user
      test_user.update!(
        vip_subscription: true,
        vip_expires_at: 1.month.from_now
      )
      puts "✅ Abonnement VIP simulé pour #{test_user.email}"
      puts "   Expire le: #{test_user.vip_expires_at.strftime('%d/%m/%Y à %H:%M')}"
    else
      puts "❌ Aucun utilisateur trouvé pour la simulation"
    end
  end
end
