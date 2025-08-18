#!/usr/bin/env ruby

# Script de test pour les récompenses exclusives
# Assurez-vous que le serveur Rails est en cours d'exécution

require 'net/http'
require 'json'
require 'uri'

puts "🎯 Test des récompenses exclusives"
puts "=" * 50

# Configuration
BASE_URL = "http://localhost:3000"
USER_EMAIL = "admin@example.com" # Remplacez par votre email

def make_request(path, method = :get, data = nil)
  uri = URI("#{BASE_URL}#{path}")
  
  case method
  when :get
    request = Net::HTTP::Get.new(uri)
  when :post
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = data.to_json if data
  end
  
  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end
  
  response
end

def login_user
  puts "\n🔐 Connexion de l'utilisateur..."
  
  # Simuler la connexion (vous devrez vous connecter manuellement dans le navigateur)
  puts "   Veuillez vous connecter manuellement dans votre navigateur avec :"
  puts "   Email: #{USER_EMAIL}"
  puts "   Passez à l'étape suivante une fois connecté..."
  
  gets.chomp
end

def check_user_badges
  puts "\n🏅 Vérification des badges de l'utilisateur..."
  
  response = make_request("/scores")
  
  if response.code == "200"
    puts "   ✅ Page des scores accessible"
    puts "   📊 Vérifiez le nombre de badges affiché sur la page"
  else
    puts "   ❌ Erreur lors de l'accès aux scores: #{response.code}"
  end
end

def unlock_rewards
  puts "\n🎁 Déblocage des récompenses..."
  
  response = make_request("/unlock_rewards", :post)
  
  if response.code == "200" || response.code == "302"
    puts "   ✅ Récompenses débloquées avec succès"
  else
    puts "   ❌ Erreur lors du déblocage: #{response.code}"
    puts "   📝 Réponse: #{response.body}"
  end
end

def check_exclusif_rewards
  puts "\n⭐ Vérification des récompenses exclusives..."
  
  response = make_request("/exclusif_rewards")
  
  if response.code == "200"
    puts "   ✅ Page des récompenses exclusives accessible"
    puts "   📱 Ouvrez cette page dans votre navigateur pour voir les détails"
  else
    puts "   ❌ Erreur lors de l'accès aux récompenses exclusives: #{response.code}"
    puts "   📝 Réponse: #{response.body}"
  end
end

def check_reward_details
  puts "\n🔍 Vérification des détails des récompenses..."
  
  # Vérifier une récompense spécifique (ID 1 par défaut)
  response = make_request("/rewards/1")
  
  if response.code == "200"
    puts "   ✅ Page de détails des récompenses accessible"
    puts "   📱 Ouvrez cette page dans votre navigateur pour voir les détails"
  else
    puts "   ❌ Erreur lors de l'accès aux détails: #{response.code}"
  end
end

def simulate_badge_acquisition
  puts "\n🎯 Simulation de l'acquisition de badges..."
  puts "   Pour tester les récompenses exclusives, vous devez avoir 6 badges"
  puts "   Voici comment procéder :"
  puts "   1. Jouez à des jeux pour gagner des badges"
  puts "   2. Ou utilisez la console Rails pour ajouter des badges manuellement"
  puts "   3. Vérifiez que vous avez au moins 6 badges"
  puts "   4. Puis testez le déblocage des récompenses exclusives"
end

def show_test_instructions
  puts "\n📋 Instructions de test :"
  puts "=" * 50
  puts "1. Assurez-vous que votre serveur Rails est en cours d'exécution"
  puts "2. Ouvrez votre navigateur et connectez-vous à l'application"
  puts "3. Vérifiez que vous avez au moins 6 badges"
  puts "4. Testez les pages suivantes :"
  puts "   - /exclusif_rewards (page des récompenses exclusives)"
  puts "   - /unlock_rewards (déblocage des récompenses)"
  puts "   - /rewards/[id] (détails d'une récompense)"
  puts "5. Vérifiez que les récompenses exclusives s'affichent correctement"
  puts "6. Testez le clic sur une récompense pour voir ses détails"
end

# Exécution du test
begin
  puts "🚀 Démarrage du test des récompenses exclusives..."
  
  # Vérifier que le serveur est accessible
  response = make_request("/")
  if response.code == "200"
    puts "   ✅ Serveur Rails accessible"
  else
    puts "   ❌ Serveur Rails non accessible. Assurez-vous qu'il est en cours d'exécution."
    exit 1
  end
  
  # Instructions de test
  show_test_instructions
  
  # Simulation de l'acquisition de badges
  simulate_badge_acquisition
  
  # Vérifications
  check_user_badges
  unlock_rewards
  check_exclusif_rewards
  check_reward_details
  
  puts "\n🎉 Test terminé !"
  puts "\n📱 Prochaines étapes :"
  puts "   1. Ouvrez /exclusif_rewards dans votre navigateur"
  puts "   2. Vérifiez que la page se charge sans erreur"
  puts "   3. Testez le déblocage des récompenses si vous avez 6 badges"
  puts "   4. Cliquez sur une récompense pour voir ses détails"
  
rescue => e
  puts "\n❌ Erreur lors du test : #{e.message}"
  puts "   Stack trace : #{e.backtrace.first(5).join("\n   ")}"
end
