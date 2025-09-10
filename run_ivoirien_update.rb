#!/usr/bin/env ruby

# Script pour exécuter la migration et le nouveau seed ivoirien
puts "🇨🇮 Exécution de la migration et du nouveau seed ivoirien"
puts "=" * 60

# Exécuter la migration
puts "\n📊 Exécution de la migration..."
system("rails db:migrate")

if $?.success?
  puts "✅ Migration exécutée avec succès"
else
  puts "❌ Erreur lors de la migration"
  exit 1
end

# Exécuter le script de mise à jour du seed
puts "\n🎵 Exécution du script de mise à jour du seed..."
system("ruby update_seed_ivoirien.rb")

if $?.success?
  puts "✅ Seed mis à jour avec succès"
else
  puts "❌ Erreur lors de la mise à jour du seed"
  exit 1
end

puts "\n🎉 Mise à jour complète terminée avec succès !"
puts "\n📊 Résumé des changements :"
puts "  - Migration des colonnes category et subcategory ajoutée"
puts "  - 10 nouvelles playlists ivoiriennes créées"
puts "  - 3 playlists standard + 7 playlists premium"
puts "  - Système de catégories Rap > Afro Rap implémenté"
puts "  - Thumbnails aléatoires des vidéos YouTube"
puts "  - Doublons corrigés dans les YouTube IDs"
puts "  - Anciennes playlists supprimées (sauf exclusives)"

puts "\n🎯 Prochaines étapes :"
puts "  1. Tester l'interface des playlists"
puts "  2. Vérifier les thumbnails YouTube"
puts "  3. Ajouter d'autres catégories musicales si nécessaire"
puts "  4. Mettre à jour les images de playlists dans app/assets/images/playlists/"

puts "\n✅ Script terminé avec succès !"
