#!/usr/bin/env ruby

# Script pour générer des mots de passe sécurisés
# Usage: ruby generer_mots_de_passe_securises.rb

require 'securerandom'

def generate_secure_password(length = 16)
  # Caractères possibles : lettres majuscules, minuscules, chiffres, symboles
  uppercase = ('A'..'Z').to_a
  lowercase = ('a'..'z').to_a
  numbers = ('0'..'9').to_a
  symbols = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '=']
  
  all_chars = uppercase + lowercase + numbers + symbols
  
  # S'assurer qu'on a au moins un caractère de chaque type
  password = [
    uppercase.sample,
    lowercase.sample,
    numbers.sample,
    symbols.sample
  ]
  
  # Remplir le reste avec des caractères aléatoires
  (length - 4).times do
    password << all_chars.sample
  end
  
  # Mélanger le mot de passe
  password.shuffle.join
end

puts "🔐 Générateur de mots de passe sécurisés"
puts "=" * 50
puts

# Générer des mots de passe pour chaque utilisateur
users = [
  { name: 'Admin', email: 'admin@tubenplay.com' },
  { name: 'Jordan', email: 'user@tubenplay.com' },
  { name: 'Driss', email: 'driss@tubenplay.com' },
  { name: 'Ja', email: 'ja@tubenplay.com' }
]

puts "📋 Mots de passe générés (16 caractères) :"
puts

passwords = {}

users.each do |user|
  password = generate_secure_password(16)
  passwords[user[:email]] = password
  puts "👤 #{user[:name]} (#{user[:email]})"
  puts "   🔑 #{password}"
  puts
end

puts "=" * 50
puts
puts "💡 Pour utiliser ces mots de passe, copiez-les dans definir_mots_de_passe.rb"
puts
puts "📝 Format à copier :"
puts
puts "PASSWORDS = {"
passwords.each do |email, password|
  user_name = users.find { |u| u[:email] == email }[:name]
  puts "  '#{email}' => '#{password}',      # #{user_name}"
end
puts "}"

