#!/usr/bin/env ruby

puts "🔍 VÉRIFICATION DES CONTENT_TYPE AUTORISÉS"
puts "=" * 60

require_relative 'config/environment'

puts "\n📋 CONTENT_TYPE EXISTANTS ACTUELLEMENT :"
puts "-" * 50

# Lister tous les content_type existants
existing_content_types = Reward.distinct.pluck(:content_type).sort
existing_content_types.each_with_index do |ct, index|
  puts "#{index + 1}. #{ct}"
end

puts "\n🔍 VÉRIFICATION DES CONTENT_TYPE AUTORISÉS :"
puts "-" * 50

# Essayer d'accéder aux content_types autorisés
if Reward.respond_to?(:content_types)
  puts "✅ Reward.content_types est accessible"
  
  begin
    allowed_types = Reward.content_types
    puts "📋 Content types autorisés :"
    if allowed_types.is_a?(Array)
      allowed_types.each_with_index do |type, index|
        puts "   #{index + 1}. #{type}"
      end
    elsif allowed_types.is_a?(Hash)
      allowed_types.each do |key, value|
        puts "   • #{key}: #{value}"
      end
    else
      puts "   Type: #{allowed_types.class} - Valeur: #{allowed_types}"
    end
  rescue => e
    puts "❌ Erreur accès content_types: #{e.message}"
  end
else
  puts "❌ Reward.content_types n'est pas accessible"
end

puts "\n🔍 VÉRIFICATION DES MÉTHODES ASSOCIÉES :"
puts "-" * 50

# Vérifier les méthodes liées aux content_type
methods_to_check = [
  :content_types,
  :content_type_enum,
  :content_type_values,
  :content_type_options,
  :content_type_list
]

methods_to_check.each do |method|
  if Reward.respond_to?(method)
    puts "✅ Reward.#{method} est accessible"
    begin
      result = Reward.send(method)
      puts "   Résultat: #{result.class} - #{result.inspect[0..100]}..."
    rescue => e
      puts "   ❌ Erreur: #{e.message}"
    end
  else
    puts "❌ Reward.#{method} n'est pas accessible"
  end
end

puts "\n🔍 VÉRIFICATION DES VALIDATIONS :"
puts "-" * 50

# Vérifier les validations spécifiques
if Reward.validators.any?
  Reward.validators.each do |validator|
    if validator.attributes.include?(:content_type)
      puts "🔒 Validation content_type trouvée:"
      puts "   • Classe: #{validator.class.name}"
      puts "   • Options: #{validator.options}"
      puts "   • Attributs: #{validator.attributes}"
    end
  end
end

puts "\n💡 ANALYSE ET RECOMMANDATIONS :"
puts "-" * 50

puts "📊 CONTENT_TYPE EXISTANTS PAR CATÉGORIE :"
puts "   🥉 Challenge: #{Reward.where(reward_type: 'challenge').distinct.pluck(:content_type).count}"
puts "   🥈 Exclusif: #{Reward.where(reward_type: 'exclusif').distinct.pluck(:content_type).count}"
puts "   🥇 Premium: #{Reward.where(reward_type: 'premium').distinct.pluck(:content_type).count}"
puts "   🌈 Ultime: #{Reward.where(reward_type: 'ultime').distinct.pluck(:content_type).count}"

puts "\n🎯 STRATÉGIE D'IMPLÉMENTATION :"
puts "   1. Utiliser les content_type existants comme base"
puts "   2. Créer des variantes avec des suffixes numériques"
puts "   3. Respecter la nomenclature existante"
puts "   4. Tester la création avec des content_type simples d'abord"

puts "\n✅ VÉRIFICATION TERMINÉE"
