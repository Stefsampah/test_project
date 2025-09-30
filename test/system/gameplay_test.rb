require "application_system_test_case"

class GameplayTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @playlist = playlists(:one)
    @video = @playlist.videos.first
  end

  test "complete game flow from playlist selection to results" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Aller à la page des playlists
    visit playlists_path
    assert_selector "h1", text: "Playlists"

    # Cliquer sur une playlist pour commencer une partie
    click_link @playlist.title
    assert_current_path playlist_path(@playlist)

    # Vérifier que la page de nouvelle partie s'affiche
    assert_selector "h1", text: "Nouvelle Partie"
    assert_selector "h2", text: "Prêt à jouer avec la playlist"
    assert_selector "p", text: @playlist.title

    # Commencer la partie
    click_button "Commencer"
    
    # Vérifier qu'on arrive sur la page de jeu
    assert_current_path playlist_game_path(@playlist, Game.last)
    assert_selector ".shorts-container"
    assert_selector ".shorts-player"

    # Vérifier que la vidéo s'affiche
    assert_selector "iframe[src*='youtube.com']"
    assert_selector ".shorts-info h2", text: @video.title

    # Effectuer un swipe (like)
    click_button "like"
    
    # Vérifier qu'on reste sur la page de jeu ou qu'on passe à la suivante
    # (selon s'il y a d'autres vidéos)
    if @playlist.videos.count > 1
      assert_current_path playlist_game_path(@playlist, Game.last)
    else
      # Si c'est la dernière vidéo, on devrait aller aux résultats
      assert_current_path results_playlist_game_path(@playlist, Game.last)
    end
  end

  test "game creation and swipe functionality" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Aller directement à une playlist
    visit playlist_path(@playlist)
    
    # Commencer une nouvelle partie
    click_button "Commencer"
    
    # Vérifier que le jeu est créé
    game = Game.last
    assert_equal @playlist, game.playlist
    assert_equal @user, game.user
    assert_nil game.completed_at

    # Vérifier l'interface de jeu
    assert_selector ".shorts-container"
    assert_selector ".action-btn.like"
    assert_selector ".action-btn.dislike"
    
    # Effectuer un swipe dislike
    click_button "dislike"
    
    # Vérifier qu'un swipe est créé
    swipe = Swipe.last
    assert_equal game, swipe.game
    assert_equal @user, swipe.user
    assert_equal @video, swipe.video
    assert_equal "dislike", swipe.action
    assert_equal false, swipe.liked
  end

  test "game completion and results display" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer un jeu avec une seule vidéo pour tester la completion
    single_video_playlist = playlists(:two)
    visit playlist_path(single_video_playlist)
    
    # Commencer la partie
    click_button "Commencer"
    
    # Effectuer un swipe pour terminer la partie
    click_button "like"
    
    # Vérifier qu'on arrive aux résultats
    game = Game.last
    assert_current_path results_playlist_game_path(single_video_playlist, game)
    
    # Vérifier que le jeu est marqué comme terminé
    game.reload
    assert_not_nil game.completed_at
    
    # Vérifier qu'un score est créé
    score = Score.find_by(user: @user, playlist: single_video_playlist)
    assert_not_nil score
    assert_equal 2, score.points # 2 points pour un like
  end

  test "premium playlist access control" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer une playlist premium
    premium_playlist = Playlist.create!(
      title: "Playlist Premium",
      description: "Test premium",
      premium: true
    )
    
    # Essayer d'accéder à la playlist premium
    visit playlist_path(premium_playlist)
    
    # Vérifier qu'on est redirigé avec un message d'erreur
    assert_current_path playlists_path
    assert_selector ".alert", text: "Vous avez besoin d'au moins 500 points"
  end

  test "reward playlist functionality" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer une playlist récompense
    reward_playlist = Playlist.create!(
      title: "Challenge Reward Playlist",
      description: "Test récompense"
    )
    
    # Ajouter une vidéo à la playlist récompense
    reward_playlist.videos.create!(
      title: "Vidéo Récompense",
      youtube_id: "test123",
      description: "Test"
    )
    
    # Accéder à la playlist récompense
    visit playlist_path(reward_playlist)
    
    # Commencer la partie
    click_button "Commencer"
    
    # Effectuer un swipe
    click_button "like"
    
    # Vérifier qu'on arrive aux résultats de récompense
    game = Game.last
    assert_current_path results_playlist_game_path(reward_playlist, game)
    
    # Vérifier que le jeu est terminé
    game.reload
    assert_not_nil game.completed_at
    
    # Vérifier qu'aucun score n'est créé pour les playlists récompenses
    score = Score.find_by(user: @user, playlist: reward_playlist)
    assert_nil score
  end

  test "game state persistence" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Commencer une partie
    visit playlist_path(@playlist)
    click_button "Commencer"
    
    game = Game.last
    
    # Effectuer quelques swipes
    click_button "like"
    click_button "dislike" if @playlist.videos.count > 1
    
    # Vérifier que les swipes sont sauvegardés
    swipes = game.swipes
    assert swipes.count > 0
    
    # Vérifier que le score est mis à jour
    score = Score.find_by(user: @user, playlist: @playlist)
    assert_not_nil score
    assert score.points > 0
  end
end
