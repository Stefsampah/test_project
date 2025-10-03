#!/usr/bin/env ruby

# Script simple pour vérifier le nombre de badges
require_relative 'config/environment'

puts "📊 Vérification des badges dans la base de données:"
puts "🔢 Nombre total de badges: #{Badge.count}"

if Badge.count > 0
  puts "\n🏅 Badges disponibles:"
  Badge.order(:badge_type, :level).each do |badge|
    puts "   #{badge.badge_type.capitalize} #{badge.level.capitalize}: #{badge.name}"
  end
else
  puts "❌ Aucun badge dans la base de données !"
  puts "💡 Il faut créer les badges via les seeds ou manuellement."
end
