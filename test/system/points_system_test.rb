require "application_system_test_case"

class PointsSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @playlist = playlists(:one)
    @video = @playlist.videos.first
  end

  test "points are awarded for likes and dislikes" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Commencer une partie
    visit playlist_path(@playlist)
    click_button "Commencer"
    
    game = Game.last
    
    # Effectuer un like (2 points)
    click_button "like"
    
    # Vérifier que le score est mis à jour
    score = Score.find_by(user: @user, playlist: @playlist)
    assert_not_nil score
    assert_equal 2, score.points
    
    # Effectuer un dislike (1 point)
    if @playlist.videos.count > 1
      click_button "dislike"
      
      # Vérifier que le score total est 3 (2 + 1)
      score.reload
      assert_equal 3, score.points
    end
  end

  test "points are not awarded for reward playlists" do
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
    
    # Ajouter une vidéo
    reward_playlist.videos.create!(
      title: "Vidéo Récompense",
      youtube_id: "test123",
      description: "Test"
    )
    
    # Jouer à la playlist récompense
    visit playlist_path(reward_playlist)
    click_button "Commencer"
    
    # Effectuer un like
    click_button "like"
    
    # Vérifier qu'aucun score n'est créé
    score = Score.find_by(user: @user, playlist: reward_playlist)
    assert_nil score
  end

  test "total points calculation" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer plusieurs playlists et jouer
    playlist1 = playlists(:one)
    playlist2 = playlists(:two)
    
    # Jouer à la première playlist
    visit playlist_path(playlist1)
    click_button "Commencer"
    click_button "like"
    
    # Jouer à la deuxième playlist
    visit playlist_path(playlist2)
    click_button "Commencer"
    click_button "like"
    
    # Vérifier que les scores sont créés
    score1 = Score.find_by(user: @user, playlist: playlist1)
    score2 = Score.find_by(user: @user, playlist: playlist2)
    
    assert_not_nil score1
    assert_not_nil score2
    
    # Vérifier que le total des points est correct
    total_points = score1.points + score2.points
    assert total_points > 0
  end

  test "points display in user profile" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Jouer à une playlist pour gagner des points
    visit playlist_path(@playlist)
    click_button "Commencer"
    click_button "like"
    
    # Aller au profil
    visit profile_path
    
    # Vérifier que les points s'affichent
    assert_selector "text", text: /points/
  end

  test "points reset when starting new game" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Jouer à une playlist
    visit playlist_path(@playlist)
    click_button "Commencer"
    click_button "like"
    
    # Vérifier qu'un score est créé
    score = Score.find_by(user: @user, playlist: @playlist)
    assert_not_nil score
    initial_points = score.points
    
    # Commencer une nouvelle partie sur la même playlist
    visit playlist_path(@playlist)
    click_button "Commencer"
    
    # Vérifier que le score est remis à zéro
    score.reload
    assert_equal 0, score.points
  end

  test "points persist after game completion" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer une playlist avec une seule vidéo
    single_video_playlist = playlists(:two)
    
    # Jouer et terminer la partie
    visit playlist_path(single_video_playlist)
    click_button "Commencer"
    click_button "like"
    
    # Vérifier que le score persiste après completion
    score = Score.find_by(user: @user, playlist: single_video_playlist)
    assert_not_nil score
    assert_equal 2, score.points
    
    # Vérifier que le score reste même après refresh
    visit profile_path
    visit playlists_path
    
    score.reload
    assert_equal 2, score.points
  end

  test "points calculation with multiple swipes" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"

    # Créer une playlist avec plusieurs vidéos
    multi_video_playlist = Playlist.create!(
      title: "Multi Video Playlist",
      description: "Test multiple videos"
    )
    
    # Ajouter plusieurs vidéos
    3.times do |i|
      multi_video_playlist.videos.create!(
        title: "Video #{i + 1}",
        youtube_id: "test#{i + 1}",
        description: "Test video #{i + 1}"
      )
    end
    
    # Jouer à la playlist
    visit playlist_path(multi_video_playlist)
    click_button "Commencer"
    
    # Effectuer plusieurs swipes
    click_button "like"    # 2 points
    click_button "dislike" # 1 point
    click_button "like"    # 2 points
    
    # Vérifier que le score total est correct
    score = Score.find_by(user: @user, playlist: multi_video_playlist)
    assert_not_nil score
    assert_equal 5, score.points # 2 + 1 + 2
  end
end
