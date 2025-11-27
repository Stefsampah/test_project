#!/usr/bin/env ruby
# Script pour supprimer les doublons et corriger les utilisateurs sur Heroku

puts "🔍 Vérification des utilisateurs..."
puts "=" * 80

# Liste tous les utilisateurs
User.all.order(:id).each do |u|
  puts "ID: #{u.id} | Email: #{u.email} | Points: #{u.points || 0} | VIP: #{u.vip_subscription || false} | Admin: #{u.admin || false}"
end

puts "\n🗑️  Suppression des utilisateurs obsolètes..."
# Supprimer les utilisateurs avec les anciens emails
obsolete_emails = ['admin@example.com', 'user@example.com']
obsolete_users = User.where(email: obsolete_emails)

if obsolete_users.any?
  puts "  Suppression de #{obsolete_users.count} utilisateurs obsolètes:"
  obsolete_users.each do |u|
    puts "    - Suppression de #{u.email} (ID: #{u.id})"
    # Supprimer les données associées
    u.games.destroy_all
    u.scores.destroy_all
    u.user_badges.destroy_all
    u.swipes.destroy_all
    u.rewards.destroy_all
    u.user_playlist_unlocks.destroy_all
    u.destroy
  end
  puts "  ✅ Utilisateurs obsolètes supprimés"
else
  puts "  ✅ Aucun utilisateur obsolète trouvé"
end

puts "\n✅ Utilisateurs finaux:"
User.all.order(:id).each do |u|
  puts "  - #{u.email}: #{u.points || 0} points, VIP: #{u.vip_subscription || false}, Admin: #{u.admin || false}"
end

puts "\n📊 Résumé:"
puts "  - Total utilisateurs: #{User.count}"

