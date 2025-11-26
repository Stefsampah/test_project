#!/bin/bash
# Script pour importer les données directement sur Heroku
# Utilise rails runner avec un script inline

echo "📥 Import des données directement sur Heroku..."

# Créer un script Ruby inline qui lit les données depuis les fichiers JSON
# et les importe directement
heroku run "rails runner \"
require 'json'

puts '📥 Import des données de jeu vers Heroku...'

# Les fichiers doivent être copiés manuellement d'abord
# Pour l'instant, on va utiliser une approche différente
# Créer les données directement depuis les exports locaux

# Pour l'instant, on va juste mettre à jour les utilisateurs
users_data = [
  {email: 'admin@tubenplay.com', points: 1000, vip_subscription: true, vip_expires_at: '2025-12-26T09:48:36.873Z', admin: true},
  {email: 'user@tubenplay.com', points: nil, vip_subscription: nil, vip_expires_at: nil, admin: false},
  {email: 'driss@tubenplay.com', points: nil, vip_subscription: nil, vip_expires_at: nil, admin: false},
  {email: 'ja@tubenplay.com', points: nil, vip_subscription: true, vip_expires_at: '2025-12-26T14:21:47.442Z', admin: false}
]

users_data.each do |user_data|
  user = User.find_by(email: user_data[:email])
  if user
    user.update!(
      points: user_data[:points] || 0,
      vip_subscription: user_data[:vip_subscription] || false,
      vip_expires_at: user_data[:vip_expires_at] ? Time.parse(user_data[:vip_expires_at]) : nil,
      admin: user_data[:admin] || false
    )
    puts \"✅ #{user.email}: #{user.points || 0} points, VIP: #{user.vip_subscription}\"
  end
end

puts '✅ Utilisateurs mis à jour'
\"" -a tubenplay-app

echo "🎉 Import terminé !"
