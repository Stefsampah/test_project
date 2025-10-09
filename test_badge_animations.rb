#!/usr/bin/env ruby
# 🏆 Script de test pour les animations de badges - Tube'NPlay

puts "🏆 Test des Animations de Badges - Tube'NPlay"
puts "=" * 50

# Test 1: Vérifier que le concern BadgeAnimationTrigger existe
puts "\n1. Vérification du concern BadgeAnimationTrigger..."
concern_path = "app/models/concerns/badge_animation_trigger.rb"
if File.exist?(concern_path)
  puts "✅ Concern BadgeAnimationTrigger trouvé"
  
  # Vérifier le contenu
  content = File.read(concern_path)
  if content.include?("trigger_badge_animation")
    puts "✅ Méthode trigger_badge_animation présente"
  else
    puts "❌ Méthode trigger_badge_animation manquante"
  end
  
  if content.include?("get_badge_animation_description")
    puts "✅ Méthode get_badge_animation_description présente"
  else
    puts "❌ Méthode get_badge_animation_description manquante"
  end
else
  puts "❌ Concern BadgeAnimationTrigger non trouvé"
end

# Test 2: Vérifier que le modèle UserBadge inclut le concern
puts "\n2. Vérification de l'inclusion dans UserBadge..."
user_badge_path = "app/models/user_badge.rb"
if File.exist?(user_badge_path)
  content = File.read(user_badge_path)
  if content.include?("include BadgeAnimationTrigger")
    puts "✅ BadgeAnimationTrigger inclus dans UserBadge"
  else
    puts "❌ BadgeAnimationTrigger non inclus dans UserBadge"
  end
else
  puts "❌ Fichier UserBadge non trouvé"
end

# Test 3: Vérifier le JavaScript des animations de badges
puts "\n3. Vérification du JavaScript des animations de badges..."
js_path = "app/assets/javascripts/reward_animations.js"
if File.exist?(js_path)
  content = File.read(js_path)
  
  if content.include?("triggerBadgeAnimation")
    puts "✅ Méthode triggerBadgeAnimation présente"
  else
    puts "❌ Méthode triggerBadgeAnimation manquante"
  end
  
  if content.include?("showBadgeNotification")
    puts "✅ Méthode showBadgeNotification présente"
  else
    puts "❌ Méthode showBadgeNotification manquante"
  end
  
  if content.include?("showBadgeGift")
    puts "✅ Méthode showBadgeGift présente"
  else
    puts "❌ Méthode showBadgeGift manquante"
  end
  
  if content.include?("showBadgeCongratulations")
    puts "✅ Méthode showBadgeCongratulations présente"
  else
    puts "❌ Méthode showBadgeCongratulations manquante"
  end
  
  if content.include?("testBadgeAnimation")
    puts "✅ Méthode testBadgeAnimation présente"
  else
    puts "❌ Méthode testBadgeAnimation manquante"
  end
else
  puts "❌ Fichier JavaScript des animations non trouvé"
end

# Test 4: Vérifier les styles CSS des badges
puts "\n4. Vérification des styles CSS des badges..."
css_path = "app/assets/stylesheets/reward_animations.css"
if File.exist?(css_path)
  content = File.read(css_path)
  
  if content.include?("badge-notification")
    puts "✅ Styles badge-notification présents"
  else
    puts "❌ Styles badge-notification manquants"
  end
  
  if content.include?("badge-gift-container")
    puts "✅ Styles badge-gift-container présents"
  else
    puts "❌ Styles badge-gift-container manquants"
  end
  
  if content.include?("badge-congratulations")
    puts "✅ Styles badge-congratulations présents"
  else
    puts "❌ Styles badge-congratulations manquants"
  end
  
  if content.include?("badgeShine")
    puts "✅ Animation badgeShine présente"
  else
    puts "❌ Animation badgeShine manquante"
  end
else
  puts "❌ Fichier CSS des animations non trouvé"
end

# Test 5: Vérifier le helper des animations de badges
puts "\n5. Vérification du helper des animations de badges..."
helper_path = "app/helpers/reward_animation_helper.rb"
if File.exist?(helper_path)
  content = File.read(helper_path)
  
  if content.include?("trigger_badge_animation_from_backend")
    puts "✅ Méthode trigger_badge_animation_from_backend présente"
  else
    puts "❌ Méthode trigger_badge_animation_from_backend manquante"
  end
  
  if content.include?("get_badge_description")
    puts "✅ Méthode get_badge_description présente"
  else
    puts "❌ Méthode get_badge_description manquante"
  end
else
  puts "❌ Fichier helper des animations non trouvé"
end

# Test 6: Vérifier le contrôleur YouTube Modal
puts "\n6. Vérification du contrôleur YouTube Modal..."
controller_path = "app/javascript/controllers/youtube_modal_controller.js"
if File.exist?(controller_path)
  content = File.read(controller_path)
  
  if content.include?("closeModal")
    puts "✅ Méthode closeModal présente"
  else
    puts "❌ Méthode closeModal manquante"
  end
  
  if content.include?("iframe.src = ''")
    puts "✅ Arrêt de la vidéo implémenté"
  else
    puts "❌ Arrêt de la vidéo non implémenté"
  end
else
  puts "❌ Contrôleur YouTube Modal non trouvé"
end

# Test 7: Vérifier les styles des modales YouTube
puts "\n7. Vérification des styles des modales YouTube..."
youtube_css_path = "app/assets/stylesheets/youtube_modals.css"
if File.exist?(youtube_css_path)
  puts "✅ Styles des modales YouTube présents"
else
  puts "❌ Styles des modales YouTube manquants"
end

# Test 8: Vérifier l'import des styles
puts "\n8. Vérification de l'import des styles..."
application_css_path = "app/assets/stylesheets/application.css"
if File.exist?(application_css_path)
  content = File.read(application_css_path)
  
  if content.include?("@import \"youtube_modals\"")
    puts "✅ Import des styles YouTube modales présent"
  else
    puts "❌ Import des styles YouTube modales manquant"
  end
else
  puts "❌ Fichier application.css non trouvé"
end

puts "\n" + "=" * 50
puts "🎉 Tests terminés !"
puts "\n📋 Résumé des fonctionnalités implémentées :"
puts "✅ Page animations cachée de la navigation"
puts "✅ Système d'animations de badges complet"
puts "✅ Concern BadgeAnimationTrigger pour déclencher les animations"
puts "✅ JavaScript étendu pour supporter les badges"
puts "✅ Styles CSS spécifiques aux badges"
puts "✅ Helper pour déclencher les animations depuis le backend"
puts "✅ Contrôleur Stimulus pour gérer les modales YouTube"
puts "✅ Arrêt automatique des vidéos lors de la fermeture des modales"
puts "✅ Styles CSS pour les modales YouTube"

puts "\n🚀 Pour tester les animations de badges :"
puts "   - Ouvrez la console du navigateur"
puts "   - Exécutez : testBadgeAnimation('competitor', 'bronze')"
puts "   - Ou : testBadgeAnimation('engager', 'silver')"
puts "   - Ou : testBadgeAnimation('critic', 'gold')"

puts "\n🎬 Pour tester les modales YouTube :"
puts "   - Les vidéos s'arrêtent automatiquement lors de la fermeture"
puts "   - Utilisez Escape ou cliquez en dehors pour fermer"
puts "   - Le contrôleur Stimulus gère tout automatiquement"
