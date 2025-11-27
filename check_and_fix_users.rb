#!/usr/bin/env ruby
# Script pour vérifier et corriger les utilisateurs sur Heroku

puts "📋 Liste des utilisateurs actuels:"
puts "=" * 80

User.all.order(:id).each do |u|
  puts "ID: #{u.id} | Email: #{u.email} | Points: #{u.points || 0} | VIP: #{u.vip_subscription || false} | Admin: #{u.admin || false}"
  puts "  Avatar: #{u.avatar.present? ? u.avatar.url : 'N/A'}"
  puts "  Created: #{u.created_at}"
  puts "-" * 80
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

