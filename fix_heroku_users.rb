#!/usr/bin/env ruby
# Script pour corriger les utilisateurs sur Heroku : supprimer doublons, corriger mots de passe, vérifier avatars
# Mots de passe UNIQUEMENT via ENV: FIX_HEROKU_ADMIN_PW, FIX_HEROKU_USER_PW, FIX_HEROKU_DRISS_PW, FIX_HEROKU_JA_PW

puts "🔍 Vérification des utilisateurs sur Heroku..."
puts "=" * 80

User.all.order(:id).each do |u|
  avatar_status = u.avatar.attached? ? "✅ Avatar présent" : "❌ Pas d'avatar"
  puts "ID: #{u.id} | Email: #{u.email} | Points: #{u.points || 0} | VIP: #{u.vip_subscription || false} | Admin: #{u.admin || false} | #{avatar_status}"
end

puts "\n🔍 Recherche des doublons..."
duplicates = User.group(:email).having('COUNT(*) > 1').count

if duplicates.any?
  puts "⚠️ Doublons trouvés:"
  duplicates.each do |email, count|
    puts "  - #{email}: #{count} occurrences"
    users = User.where(email: email).order(:id)
    users.each do |u|
      puts "    ID #{u.id}: #{u.points || 0} points, VIP: #{u.vip_subscription}, Admin: #{u.admin}, Created: #{u.created_at}"
    end
  end
else
  puts "✅ Aucun doublon trouvé"
end

puts "\n🗑️  Suppression des utilisateurs obsolètes..."
obsolete_emails = ['admin@example.com', 'user@example.com']
obsolete_users = User.where(email: obsolete_emails)

if obsolete_users.any?
  puts "  Suppression de #{obsolete_users.count} utilisateurs obsolètes:"
  obsolete_users.each do |u|
    puts "    - Suppression de #{u.email} (ID: #{u.id})"
    u.games.destroy_all
    u.scores.destroy_all
    u.user_badges.destroy_all
    u.swipes.destroy_all
    u.rewards.destroy_all if u.respond_to?(:rewards)
    u.user_playlist_unlocks.destroy_all if u.respond_to?(:user_playlist_unlocks)
    u.destroy
  end
  puts "  ✅ Utilisateurs obsolètes supprimés"
else
  puts "  ✅ Aucun utilisateur obsolète trouvé"
end

puts "\n🔧 Correction des doublons (garder celui avec le plus de points)..."
if duplicates.any?
  duplicates.each do |email, count|
    users = User.where(email: email).order(:id)
    if users.count > 1
      keep_user = users.max_by { |u| [u.points || 0, u.created_at] }
      delete_users = users - [keep_user]
      puts "  📌 Garder: ID #{keep_user.id} (#{keep_user.points || 0} points)"
      delete_users.each do |u|
        puts "    🗑️  Supprimer: ID #{u.id} (#{u.points || 0} points)"
        u.games.update_all(user_id: keep_user.id)
        u.scores.update_all(user_id: keep_user.id)
        u.user_badges.update_all(user_id: keep_user.id)
        u.swipes.update_all(user_id: keep_user.id)
        u.rewards.update_all(user_id: keep_user.id) if u.respond_to?(:rewards)
        u.user_playlist_unlocks.update_all(user_id: keep_user.id) if u.respond_to?(:user_playlist_unlocks)
        u.destroy
      end
    end
  end
end

puts "\n🔐 Correction des mots de passe (via ENV)..."
passwords = {
  'admin@tubenplay.com' => ENV['FIX_HEROKU_ADMIN_PW'],
  'user@tubenplay.com' => ENV['FIX_HEROKU_USER_PW'],
  'driss@tubenplay.com' => ENV['FIX_HEROKU_DRISS_PW'],
  'ja@tubenplay.com' => ENV['FIX_HEROKU_JA_PW']
}.compact

if passwords.empty?
  puts "  ⚠️ Aucune variable FIX_HEROKU_*_PW définie. Heroku: heroku config:set FIX_HEROKU_ADMIN_PW=xxx ..."
else
  passwords.each do |email, password|
    next if password.blank?
    user = User.find_by(email: email)
    if user
      user.update(password: password, password_confirmation: password)
      puts "  ✅ Mot de passe mis à jour pour #{email}"
    else
      puts "  ⚠️ Utilisateur #{email} non trouvé"
    end
  end
end

puts "\n👑 Vérification des abonnements VIP..."
ja = User.find_by(email: 'ja@tubenplay.com')
if ja
  unless ja.vip_subscription
    ja.update(vip_subscription: true, vip_expires_at: 1.year.from_now)
    puts "  ✅ Abonnement VIP activé pour ja@tubenplay.com"
  else
    puts "  ✅ ja@tubenplay.com a déjà un abonnement VIP"
  end
end

puts "\n✅ Utilisateurs finaux:"
User.all.order(:id).each do |u|
  avatar_status = u.avatar.attached? ? "✅ Avatar" : "❌ Pas d'avatar"
  puts "  - #{u.email}: #{u.points || 0} points, VIP: #{u.vip_subscription || false}, Admin: #{u.admin || false}, #{avatar_status}"
end

puts "\n📊 Résumé:"
puts "  - Total utilisateurs: #{User.count}"
puts "  - Utilisateurs avec avatars: #{User.joins(:avatar_attachment).count}"
