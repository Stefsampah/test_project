#!/usr/bin/env ruby

# Test d'affichage des portraits NFT
require_relative 'config/environment'

puts "🧪 Test d'affichage des Portraits NFT"
puts "=" * 50

# NFT configurations actuelles
nft_rewards = [
  {
    content_type: 'didi_b_nft',
    title: 'DIDI B - PHOTO EXCLUSIVE NFT',
    description: 'Rapper, songwriter, performer, entrepreneur, Afro-urban visionary',
    icon: '🖼️',
    color: 'from-purple-400 to-pink-500'
  },
  {
    content_type: 'okenneth_nft',
    title: 'O\'KENNETH - PHOTO EXCLUSIVE NFT', 
    description: 'Ghanaian rapper, raw voice of Kumasi, Asakaa drill pioneer',
    icon: '🖼️',
    color: 'from-green-400 to-blue-500'
  },
  {
    content_type: 'chuwi_nft',
    title: 'CHUWI - PHOTO EXCLUSIVE NFT',
    description: 'Indie tropical band from Isabela, Puerto Rico',
    icon: '🖼️',
    color: 'from-orange-400 to-red-500'
  },
  {
    content_type: 'punk_duo_nft',
    title: 'PUNK DUO - PHOTO EXCLUSIVE NFT',
    description: 'Punk duo from Brighton, UK, queer, neurodivergent',
    icon: '🖼️',
    color: 'from-red-400 to-purple-500'
  },
  {
    content_type: 'koffee_nft',
    title: 'KOFFEE - PHOTO EXCLUSIVE NFT',
    description: 'KOFFEE #1 Reggae artist from Spanish Town',
    icon: '🖼️',
    color: 'from-yellow-400 to-green-500'
  }
]

puts "\n📋 URLs pour tester dans le navigateur :"
puts "\n🎯 Page principale :"
puts "http://localhost:3000/rewards"
puts "http://localhost:3000/my_rewards"

puts "\n🖼️ Contenu NFT à tester :"
nft_rewards.each do |nft |
  puts "\n--- #{nft[:title]} ---"
  puts "Type: #{nft[:content_type]}"
  puts "Description: #{nft[:description]}"
  puts "Couleur: #{nft[:color]}"
  puts "Icône: #{nft[:icon]}"
  puts "Pour tester: Créer une récompense avec content_type: '#{nft[:content_type]}'"
end

puts "\n🔧 Pour créer des NFTs de test :"
puts "1. Se connecter comme utilisateur avec 9+ badges"
puts "2. Aller sur http://localhost:3000/my_rewards"
puts "3. Vérifier l'affichage des récompenses Premium"
puts "4. Tester l'affichage avec reward_details?content_type=x"

puts "\n📱 URLs spécifiques :"
puts "http://localhost:3000/reward_details?content_type=didi_b_nft"
puts "http://localhost:3000/reward_details?content_type=okenneth_nft"
puts "http://localhost:3000/reward_details?content_type=chuwi_nft"
puts "http://localhost:3000/reward_details?content_type=punk_duo_nft"
puts "http://localhost:3000/reward_details?content_type=koffee_nft"

puts "\n✅ Test terminé !"
