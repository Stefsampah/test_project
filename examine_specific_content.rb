#!/usr/bin/env ruby

puts "🔍 EXAMEN DÉTAILLÉ DU CONTENU SPÉCIFIQUE DES RÉCOMPENSES EXCLUSIVES"
puts "=" * 80

require_relative 'config/environment'

# Récupérer les récompenses exclusives spécifiques
documentary_rewards = Reward.where(reward_type: 'exclusif', content_type: 'documentary')
blog_rewards = Reward.where(reward_type: 'exclusif', content_type: 'blog_article')
diversified_rewards = Reward.where(reward_type: 'exclusif', content_type: 'le_type')

puts "\n📊 RÉCAPITULATIF DES TYPES DE CONTENU"
puts "-" * 50
puts "🎬 Documentaires : #{documentary_rewards.count} récompense(s)"
puts "📝 Articles blog : #{blog_rewards.count} récompense(s)"
puts "🎁 Contenu diversifié : #{diversified_rewards.count} récompense(s)"

# Examiner les documentaires
puts "\n🎬 ANALYSE DÉTAILLÉE DES DOCUMENTAIRES"
puts "=" * 60

if documentary_rewards.any?
  documentary_rewards.each_with_index do |reward, index|
    puts "\n📹 Documentaire ##{index + 1}"
    puts "   🆔 ID : #{reward.id}"
    puts "   👤 Utilisateur : #{reward.user_id}"
    puts "   🏷️ Badge type : #{reward.badge_type}"
    puts "   🔢 Quantité requise : #{reward.quantity_required}"
    puts "   📅 Créé le : #{reward.created_at}"
    puts "   🔓 Débloqué : #{reward.unlocked? ? 'Oui' : 'Non'}"
    puts "   📅 Débloqué le : #{reward.unlocked_at}" if reward.unlocked?
    puts "   🎯 Claimé : #{reward.claimed? ? 'Oui' : 'Non'}"
    puts "   📅 Claimé le : #{reward.claimed_at}" if reward.claimed?
    puts "   🎨 Icône : #{reward.respond_to?(:icon) ? (reward.icon || 'Aucune') : 'Attribut non disponible'}"
    
    # Essayer de récupérer plus d'informations sur le contenu
    puts "\n   📋 CONTENU DU DOCUMENTAIRE :"
    puts "      • Type : Documentaire exclusif"
    puts "      • Format : Film documentaire"
    puts "      • Durée : À définir"
    puts "      • Thème : À définir"
    puts "      • Artistes présentés : À définir"
    puts "      • Événements couverts : À définir"
  end
else
  puts "❌ Aucun documentaire trouvé"
end

# Examiner les articles blog
puts "\n📝 ANALYSE DÉTAILLÉE DES ARTICLES BLOG"
puts "=" * 60

if blog_rewards.any?
  blog_rewards.each_with_index do |reward, index|
    puts "\n📰 Article Blog ##{index + 1}"
    puts "   🆔 ID : #{reward.id}"
    puts "   👤 Utilisateur : #{reward.user_id}"
    puts "   🏷️ Badge type : #{reward.badge_type}"
    puts "   🔢 Quantité requise : #{reward.quantity_required}"
    puts "   📅 Créé le : #{reward.created_at}"
    puts "   🔓 Débloqué : #{reward.unlocked? ? 'Oui' : 'Non'}"
    puts "   📅 Débloqué le : #{reward.unlocked_at}" if reward.unlocked?
    puts "   🎯 Claimé : #{reward.claimed? ? 'Oui' : 'Non'}"
    puts "   📅 Claimé le : #{reward.claimed_at}" if reward.claimed?
    puts "   🎨 Icône : #{reward.respond_to?(:icon) ? (reward.icon || 'Aucune') : 'Attribut non disponible'}"
    
    puts "\n   📋 CONTENU DE L'ARTICLE :"
    puts "      • Type : Article blog spécialisé"
    puts "      • Format : Article texte + médias"
    puts "      • Longueur : À définir"
    puts "      • Sujet : À définir"
    puts "      • Auteur : À définir"
    puts "      • Médias inclus : Photos, vidéos, audio"
  end
else
  puts "❌ Aucun article blog trouvé"
end

# Examiner le contenu diversifié
puts "\n🎁 ANALYSE DÉTAILLÉE DU CONTENU DIVERSIFIÉ"
puts "=" * 60

if diversified_rewards.any?
  diversified_rewards.each_with_index do |reward, index|
    puts "\n🌟 Contenu Diversifié ##{index + 1}"
    puts "   🆔 ID : #{reward.id}"
    puts "   👤 Utilisateur : #{reward.user_id}"
    puts "   🏷️ Badge type : #{reward.badge_type}"
    puts "   🔢 Quantité requise : #{reward.quantity_required}"
    puts "   📅 Créé le : #{reward.created_at}"
    puts "   🔓 Débloqué : #{reward.unlocked? ? 'Oui' : 'Non'}"
    puts "   📅 Débloqué le : #{reward.unlocked_at}" if reward.unlocked?
    puts "   🎯 Claimé : #{reward.claimed? ? 'Oui' : 'Non'}"
    puts "   📅 Claimé le : #{reward.claimed_at}" if reward.claimed?
    puts "   🎨 Icône : #{reward.respond_to?(:icon) ? (reward.icon || 'Aucune') : 'Attribut non disponible'}"
    
    puts "\n   📋 CONTENU DIVERSIFIÉ :"
    puts "      • Type : Contenu exclusif spécial"
    puts "      • Format : À définir (probablement mixte)"
    puts "      • Nature : Contenu unique et varié"
    puts "      • Thème : Probablement transversal"
    puts "      • Valeur ajoutée : Contenu rare et exclusif"
  end
else
  puts "❌ Aucun contenu diversifié trouvé"
end

# Vérifier s'il y a des informations supplémentaires dans la base
puts "\n🔍 RECHERCHE D'INFORMATIONS SUPPLÉMENTAIRES"
puts "=" * 60

puts "\n📚 Vérification des modèles de contenu..."
puts "   • Modèle Reward : #{Reward.column_names.join(', ')}"

# Vérifier s'il y a des relations avec d'autres modèles
puts "\n🔗 Vérification des relations..."
puts "   • Associations Reward : #{Reward.reflect_on_all_associations.map(&:name).join(', ')}"

# Vérifier s'il y a des attributs personnalisés ou des métadonnées
puts "\n📊 Vérification des attributs personnalisés..."
puts "   • Attributs Reward : #{Reward.attribute_names.join(', ')}"

puts "\n💡 ANALYSE ET RECOMMANDATIONS"
puts "=" * 50

puts "\n🎬 POUR LES DOCUMENTAIRES :"
puts "   • Besoin d'ajouter des métadonnées : titre, durée, thème, artistes"
puts "   • Créer des catégories : histoire du rap, artistes, événements, culture"
puts "   • Ajouter des descriptions détaillées du contenu"

puts "\n📝 POUR LES ARTICLES BLOG :"
puts "   • Besoin d'ajouter des métadonnées : titre, sujet, auteur, longueur"
puts "   • Créer des catégories : analyses, interviews, critiques, actualités"
puts "   • Ajouter des résumés et mots-clés"

puts "\n🎁 POUR LE CONTENU DIVERSIFIÉ :"
puts "   • Définir précisément le type de contenu"
puts "   • Ajouter des métadonnées spécifiques"
puts "   • Créer des catégories claires"

puts "\n✅ CONCLUSION"
puts "=" * 30
puts "Ces récompenses existent mais manquent de détails sur leur contenu réel."
puts "Il faut enrichir les métadonnées pour une meilleure expérience utilisateur."
puts "Suggestion : Créer un système de métadonnées pour chaque type de contenu."
