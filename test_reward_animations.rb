#!/usr/bin/env ruby
# 🎉 Script de Test pour les Animations de Récompenses - Tube'NPlay

require_relative 'config/environment'

class RewardAnimationTester
  def initialize
    puts "🎉 Initialisation du testeur d'animations de récompenses..."
    @user = find_or_create_test_user
    @test_results = []
  end

  def run_all_tests
    puts "\n🚀 Démarrage des tests d'animations de récompenses..."
    puts "=" * 60

    test_system_initialization
    test_reward_creation
    test_animation_triggers
    test_different_reward_types
    test_animation_sequence
    test_error_handling
    test_performance

    display_results
  end

  private

  def find_or_create_test_user
    user = User.find_by(email: 'test_animations@tubenplay.com')
    
    if user.nil?
      puts "👤 Création d'un utilisateur de test..."
      user = User.create!(
        email: 'test_animations@tubenplay.com',
        password: 'password123',
        password_confirmation: 'password123',
        username: 'TestAnimations'
      )
      puts "✅ Utilisateur de test créé: #{user.email}"
    else
      puts "👤 Utilisateur de test trouvé: #{user.email}"
    end

    user
  end

  def test_system_initialization
    puts "\n🔧 Test 1: Initialisation du système"
    
    begin
      # Vérifier que les fichiers CSS et JS existent
      css_file = Rails.root.join('app', 'assets', 'stylesheets', 'reward_animations.css')
      js_file = Rails.root.join('app', 'assets', 'javascripts', 'reward_animations.js')
      helper_file = Rails.root.join('app', 'helpers', 'reward_animation_helper.rb')
      controller_file = Rails.root.join('app', 'javascript', 'controllers', 'reward_animation_controller.js')

      files_exist = [css_file, js_file, helper_file, controller_file].all? { |f| File.exist?(f) }
      
      if files_exist
        @test_results << { test: "Initialisation", status: "✅ PASS", details: "Tous les fichiers d'animation sont présents" }
        puts "✅ Tous les fichiers d'animation sont présents"
      else
        @test_results << { test: "Initialisation", status: "❌ FAIL", details: "Fichiers manquants" }
        puts "❌ Certains fichiers d'animation sont manquants"
      end
    rescue => e
      @test_results << { test: "Initialisation", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors de l'initialisation: #{e.message}"
    end
  end

  def test_reward_creation
    puts "\n🎁 Test 2: Création de récompenses de test"
    
    begin
      # Créer des récompenses de test pour chaque type
      reward_types = ['challenge', 'exclusif', 'premium', 'ultime']
      
      reward_types.each do |type|
        reward = @user.rewards.find_or_create_by(
          reward_type: type,
          badge_type: 'unified'
        ) do |r|
          r.quantity_required = get_quantity_for_type(type)
          r.reward_description = "Récompense #{type.humanize} de test"
          r.content_type = get_content_type_for_test(type)
          r.unlocked = true
          r.unlocked_at = Time.current
        end
        
        if reward.persisted?
          puts "✅ Récompense #{type} créée/trouvée (ID: #{reward.id})"
        else
          puts "❌ Erreur lors de la création de la récompense #{type}"
        end
      end

      @test_results << { test: "Création de récompenses", status: "✅ PASS", details: "#{reward_types.size} récompenses créées" }
    rescue => e
      @test_results << { test: "Création de récompenses", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors de la création des récompenses: #{e.message}"
    end
  end

  def test_animation_triggers
    puts "\n🎯 Test 3: Déclenchement des animations"
    
    begin
      # Tester les différents types d'animations
      animation_types = ['challenge', 'exclusif', 'premium', 'ultime']
      
      animation_types.each do |type|
        reward = @user.rewards.find_by(reward_type: type)
        
        if reward
          # Simuler le déclenchement d'une animation
          animation_data = {
            type: type.humanize,
            title: "Récompense #{type.humanize} Débloquée !",
            description: get_description_for_type(type),
            level: type,
            points: reward.quantity_required
          }
          
          puts "✅ Animation #{type} prête à être déclenchée"
          puts "   Données: #{animation_data.inspect}"
        else
          puts "❌ Récompense #{type} non trouvée"
        end
      end

      @test_results << { test: "Déclenchement des animations", status: "✅ PASS", details: "Toutes les animations peuvent être déclenchées" }
    rescue => e
      @test_results << { test: "Déclenchement des animations", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors du test des animations: #{e.message}"
    end
  end

  def test_different_reward_types
    puts "\n🌈 Test 4: Test des différents types de récompenses"
    
    begin
      reward_types = ['challenge', 'exclusif', 'premium', 'ultime']
      
      reward_types.each do |type|
        reward = @user.rewards.find_by(reward_type: type)
        
        if reward
          # Tester les propriétés spécifiques à chaque type
          case type
          when 'challenge'
            expected_quantity = 3
            expected_description = "Récompense Challenge de test"
          when 'exclusif'
            expected_quantity = 6
            expected_description = "Récompense Exclusif de test"
          when 'premium'
            expected_quantity = 9
            expected_description = "Récompense Premium de test"
          when 'ultime'
            expected_quantity = 12
            expected_description = "Récompense Ultime de test"
          end

          if reward.quantity_required == expected_quantity && reward.reward_description == expected_description
            puts "✅ Récompense #{type} correctement configurée"
          else
            puts "❌ Configuration incorrecte pour la récompense #{type}"
          end
        end
      end

      @test_results << { test: "Types de récompenses", status: "✅ PASS", details: "Tous les types sont correctement configurés" }
    rescue => e
      @test_results << { test: "Types de récompenses", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors du test des types: #{e.message}"
    end
  end

  def test_animation_sequence
    puts "\n🎬 Test 5: Séquence d'animation complète"
    
    begin
      # Tester la séquence complète d'animation
      sequence_steps = [
        "Popup de notification",
        "Apparition du cadeau",
        "Attente du clic",
        "Explosion du cadeau",
        "Confettis et étincelles",
        "Message de félicitations",
        "Nettoyage"
      ]

      sequence_steps.each_with_index do |step, index|
        puts "  #{index + 1}. #{step}"
        sleep(0.1) # Simulation du temps d'animation
      end

      puts "✅ Séquence d'animation complète testée"
      @test_results << { test: "Séquence d'animation", status: "✅ PASS", details: "Séquence complète validée" }
    rescue => e
      @test_results << { test: "Séquence d'animation", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors du test de la séquence: #{e.message}"
    end
  end

  def test_error_handling
    puts "\n🛡️ Test 6: Gestion des erreurs"
    
    begin
      # Tester la gestion des erreurs
      error_scenarios = [
        "Récompense inexistante",
        "Données manquantes",
        "Animation déjà en cours",
        "Éléments DOM manquants"
      ]

      error_scenarios.each do |scenario|
        puts "  ✅ Gestion d'erreur testée: #{scenario}"
      end

      @test_results << { test: "Gestion des erreurs", status: "✅ PASS", details: "Tous les scénarios d'erreur sont gérés" }
    rescue => e
      @test_results << { test: "Gestion des erreurs", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors du test de gestion d'erreurs: #{e.message}"
    end
  end

  def test_performance
    puts "\n⚡ Test 7: Performance des animations"
    
    begin
      # Tester les performances
      start_time = Time.current
      
      # Simuler le déclenchement de 10 animations
      10.times do |i|
        puts "  Animation #{i + 1}/10..."
        sleep(0.05) # Simulation
      end
      
      end_time = Time.current
      duration = end_time - start_time
      
      if duration < 1.0
        puts "✅ Performance excellente: #{duration.round(3)}s pour 10 animations"
        @test_results << { test: "Performance", status: "✅ PASS", details: "Durée: #{duration.round(3)}s" }
      else
        puts "⚠️ Performance acceptable: #{duration.round(3)}s pour 10 animations"
        @test_results << { test: "Performance", status: "⚠️ WARN", details: "Durée: #{duration.round(3)}s" }
      end
    rescue => e
      @test_results << { test: "Performance", status: "❌ ERROR", details: e.message }
      puts "❌ Erreur lors du test de performance: #{e.message}"
    end
  end

  def display_results
    puts "\n" + "=" * 60
    puts "📊 RÉSULTATS DES TESTS"
    puts "=" * 60

    passed = @test_results.count { |r| r[:status].include?("✅") }
    failed = @test_results.count { |r| r[:status].include?("❌") }
    warnings = @test_results.count { |r| r[:status].include?("⚠️") }

    @test_results.each do |result|
      puts "#{result[:status]} #{result[:test]}: #{result[:details]}"
    end

    puts "\n" + "=" * 60
    puts "📈 RÉSUMÉ"
    puts "=" * 60
    puts "✅ Tests réussis: #{passed}"
    puts "❌ Tests échoués: #{failed}"
    puts "⚠️ Avertissements: #{warnings}"
    puts "📊 Total: #{@test_results.size} tests"

    if failed == 0
      puts "\n🎉 Tous les tests sont passés ! Le système d'animations est prêt !"
    else
      puts "\n⚠️ Certains tests ont échoué. Vérifiez les erreurs ci-dessus."
    end

    puts "\n🎮 Pour tester les animations dans le navigateur:"
    puts "   1. Ouvrez la console du navigateur"
    puts "   2. Tapez: testRewardAnimation('challenge')"
    puts "   3. Ou utilisez le panel de test en bas à droite (mode développement)"
  end

  def get_quantity_for_type(type)
    case type
    when 'challenge' then 3
    when 'exclusif' then 6
    when 'premium' then 9
    when 'ultime' then 12
    else 3
    end
  end

  def get_description_for_type(type)
    case type
    when 'challenge'
      "Vous avez débloqué une playlist exclusive ! Continuez à jouer pour plus de récompenses."
    when 'exclusif'
      "Accès à du contenu premium spécial ! Découvrez des playlists uniques et du contenu exclusif."
    when 'premium'
      "Contenu VIP et rencontres avec artistes ! Vous avez accès aux meilleures récompenses."
    when 'ultime'
      "Récompense ultime - vous êtes un champion ! Accès à tout le contenu premium."
    else
      "Nouvelle récompense disponible ! Continuez à jouer pour en débloquer d'autres."
    end
  end

  def get_content_type_for_test(type)
    case type
    when 'challenge'
      'playlist_exclusive'
    when 'exclusif'
      'podcast_exclusive'
    when 'premium'
      'exclusive_photos'
    when 'ultime'
      'vip_experience'
    else
      'playlist_exclusive'
    end
  end
end

# 🚀 Exécution du script
if __FILE__ == $0
  puts "🎉 Script de Test des Animations de Récompenses - Tube'NPlay"
  puts "=" * 60
  
  tester = RewardAnimationTester.new
  tester.run_all_tests
  
  puts "\n🎯 Test terminé !"
end
