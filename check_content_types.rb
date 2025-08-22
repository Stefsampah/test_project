#!/usr/bin/env ruby

puts "🔍 VÉRIFICATION DES CONTENT_TYPE EXISTANTS ET CONTRAINTES"
puts "=" * 70

require_relative 'config/environment'

puts "\n📊 CONTENT_TYPE EXISTANTS PAR TYPE DE RÉCOMPENSE"
puts "-" * 60

# Vérifier les content_type existants par reward_type
Reward.distinct.pluck(:reward_type).each do |reward_type|
  puts "\n🎯 #{reward_type.upcase} :"
  content_types = Reward.where(reward_type: reward_type).distinct.pluck(:content_type)
  content_types.each do |ct|
    puts "   • #{ct}"
  end
end

puts "\n🔍 ANALYSE DES CONTRAINTES DU MODÈLE"
puts "-" * 50

# Vérifier s'il y a des validations sur content_type
puts "📋 Attributs du modèle Reward :"
Reward.column_names.each do |attr|
  puts "   • #{attr}"
end

puts "\n🔒 Validations du modèle Reward :"
if Reward.respond_to?(:validators)
  Reward.validators.each do |validator|
    puts "   • #{validator.class.name}: #{validator.options}"
  end
else
  puts "   • Aucune validation trouvée"
end

puts "\n📚 Vérification des enums ou contraintes..."
puts "   • Reward.respond_to?(:content_types) : #{Reward.respond_to?(:content_types)}"
puts "   • Reward.respond_to?(:content_type_enum) : #{Reward.respond_to?(:content_type_enum)}"

# Essayer de voir s'il y a des constantes définies
puts "\n🔍 Constantes du modèle Reward :"
Reward.constants.each do |const|
  puts "   • #{const} = #{Reward.const_get(const)}"
end

puts "\n💡 RECOMMANDATIONS"
puts "-" * 30
puts "1. Vérifier s'il y a des validations sur content_type"
puts "2. Identifier les content_type autorisés"
puts "3. Adapter le script d'implémentation en conséquence"
puts "4. Utiliser des content_type existants ou valides"

puts "\n✅ VÉRIFICATION TERMINÉE"
