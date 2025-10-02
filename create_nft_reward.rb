#!/usr/bin/env ruby

# Créer une récompense NFT spécifique pour tester l'affichage
require_relative 'config/environment'

puts "🎨 Création d'une récompense NFT de test"
puts "=" * 50

# Trouver l'admin
admin = User.find_by(email: 'admin@example.com')
if admin.nil?
  puts "❌ Admin non trouvé"
  exit 1
end

puts "👤 Admin: #{admin.email}"
puts "🏆 Badges: #{admin.user_badges.count}"
puts "💰 Points: #{admin.total_points}"

# Supprimer l'ancienne récompense NFT s'il y en a une
admin.rewards.where(content_type: 'didi_b_nft').destroy_all

# Créer une récompense NFT Didi B de test avec parameters uniques
nft_reward = admin.rewards.create!(
  badge_type: 'nft_unified',
  quantity_required: 12,
  reward_type: 'ultime',
  content_type: 'didi_b_nft',
  reward_description: 'Photo exclusive NFT de Didi B en studio - Collection spéciale limitée',
  unlocked: true,
  unlocked_at: Time.current
)

puts "\n🎉 Récompense NFT créée avec succès !"
puts "📊 Détails de la récompense:"
puts "   - Type: #{nft_reward.reward_type}"
puts "   - Contenu: #{nft_reward.content_type}"
puts "   - Titre: #{nft_reward.reward_description}"
puts "   - Badges requis: #{nft_reward.quantity_required}"
puts "   - Débloquée: #{nft_reward.unlocked? ? '✅ Oui' : '❌ Non'}"

# Créer aussi les autres NFTs de test
nft_types = [
  'okenneth_nft',
  'chuwi_nft', 
  'punk_duo_nft',
  'koffee_nft'
]

puts "\n🎖️ Création des autres NFTs..."

nft_types.each do |content_type|
  nft_name = content_type.gsub('_nft', '').upcase
  
  # Supprimer l'ancienne récompense s'il y en a une
  admin.rewards.where(content_type: content_type).destroy_all
  
  # Créer avec badge_type unique pour éviter la contrainte
  badge_type = "nft_#{content_type.gsub('_nft', '')}"
  
  nft_reward = admin.rewards.create!(
    badge_type: badge_type,
    quantity_required: 12,
    reward_type: 'ultime',
    content_type: content_type,
    reward_description: "Photo exclusive NFT de #{nft_name} - Collection premium unique",
    unlocked: true,
    unlocked_at: Time.current
  )
  
  puts "  ✅ #{nft_name} NFT créé"
end

total_rewards = admin.rewards.count
puts "\n🎯 Total des récompenses: #{total_rewards}"

puts "\n🔗 URLs pour tester maintenant:"
puts "http://localhost:3000/reward_details?content_type=didi_b_nft"
puts "http://localhost:3000/reward_details?content_type=okenneth_nft"
puts "http://localhost:3000/reward_details?content_type=chuwi_nft"
puts "http://localhost:3000/reward_details?content_type=punk_duo_nft"
puts "http://localhost:3000/reward_details?content_type=koffee_nft"

puts "\n✅ NFTs créés avec succès !"
