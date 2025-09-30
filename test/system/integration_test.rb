require "application_system_test_case"

class IntegrationTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @premium_playlist = playlists(:two)
  end

  test "complete user journey from registration to game completion" do
    # 1. User visits the site
    visit root_url
    assert_selector "h1", text: "Welcome"
    
    # 2. User registers
    click_on "Sign up"
    fill_in "Email", with: "newuser@example.com"
    fill_in "Mot de passe", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"
    
    # Should be redirected and logged in
    assert_text "Welcome! You have signed up successfully"
    
    # 3. User browses playlists
    visit playlists_url
    assert_selector "h1", text: "Playlists"
    
    # 4. User selects a playlist
    click_on @playlist.title
    assert_selector "h1", text: @playlist.title
    
    # 5. User starts a game
    click_button "Start Game"
    assert_selector "h1", text: "Game"
    
    # 6. User plays the game
    video = @playlist.videos.first
    if video
      # Like the video
      click_button "Like"
      assert_text "Video liked"
      
      # Check if there's a next video
      if @playlist.videos.count > 1
        assert_text "Next video"
      else
        assert_text "Game completed"
      end
    end
    
    # 7. User views their profile
    visit profile_url(@user)
    assert_selector "h1", text: /🎯/
    
    # 8. User checks their scores
    visit scores_url
    assert_selector "h1", text: "Scores"
  end

  test "complete premium playlist unlock journey" do
    # 1. User signs in
    sign_in @user
    @user.update!(game_points: 1000) # Give user enough points
    
    # 2. User visits store
    visit store_url
    assert_selector "h1", text: "Store"
    
    # 3. User views premium playlists
    click_on "Premium Playlists"
    assert_text "Premium content"
    
    # 4. User selects a premium playlist
    visit playlist_url(@premium_playlist)
    assert_text "Premium"
    assert_text "500 points required"
    
    # 5. User unlocks the playlist
    click_button "Unlock"
    assert_text "Playlist unlocked successfully"
    
    # 6. User starts playing the premium playlist
    click_button "Start Game"
    assert_selector "h1", text: "Game"
    
    # 7. User completes the game
    video = @premium_playlist.videos.first
    if video
      click_button "Like"
      assert_text "Video liked"
    end
    
    # 8. User checks their updated points
    visit profile_url(@user)
    assert_text "500 points" # Should have 500 points left
  end

  test "complete badge earning journey" do
    # 1. User signs in
    sign_in @user
    
    # 2. User plays multiple games to earn points
    @playlist.videos.each do |video|
      game = Game.create!(user: @user, playlist: @playlist)
      Swipe.create!(user: @user, video: video, game: game, action: 'like', liked: true, playlist: @playlist)
    end
    
    # 3. User checks their badges
    visit badges_url
    assert_selector "h1", text: "Badges"
    
    # 4. User views their progress
    click_on "Your Badges"
    assert_text "Progress"
    
    # 5. User earns a badge (simulate)
    badge = Badge.create!(
      name: "Test Badge",
      badge_type: "competitor",
      level: "bronze",
      points_required: 100,
      description: "Test badge"
    )
    
    UserBadge.create!(user: @user, badge: badge, earned_at: Time.current)
    
    # 6. User views their earned badge
    visit badge_url(badge)
    assert_text "Earned"
    
    # 7. User checks their rewards
    visit rewards_url
    assert_selector "h1", text: "Rewards"
  end

  test "complete reward unlocking journey" do
    # 1. User signs in
    sign_in @user
    
    # 2. User earns a badge
    badge = Badge.create!(
      name: "Test Badge",
      badge_type: "competitor",
      level: "bronze",
      points_required: 100,
      description: "Test badge"
    )
    
    UserBadge.create!(user: @user, badge: badge, earned_at: Time.current)
    
    # 3. User checks available rewards
    visit rewards_url
    assert_selector "h1", text: "Rewards"
    
    # 4. User views a specific reward
    reward = Reward.create!(
      user: @user,
      badge_type: "competitor",
      quantity_required: 1,
      reward_type: "challenge",
      reward_description: "Test reward",
      content_type: "playlist_exclusive"
    )
    
    visit reward_url(reward)
    assert_text "Test reward"
    
    # 5. User unlocks the reward
    reward.update!(unlocked: true)
    
    # 6. User accesses the unlocked content
    assert_text "Unlocked"
    assert_text "Download"
    assert_text "Stream"
  end

  test "complete store purchase journey" do
    # 1. User signs in
    sign_in @user
    @user.update!(game_points: 100) # Give user some points
    
    # 2. User visits store
    visit store_url
    assert_selector "h1", text: "Store"
    
    # 3. User views points packages
    click_on "Points Packages"
    assert_text "100 points"
    assert_text "500 points"
    assert_text "1000 points"
    
    # 4. User purchases points (simulate)
    @user.update!(game_points: 600) # Simulate purchase
    
    # 5. User unlocks premium content
    visit playlist_url(@premium_playlist)
    click_button "Unlock"
    assert_text "Playlist unlocked successfully"
    
    # 6. User checks purchase history
    visit store_url
    click_on "Purchase History"
    assert_text "Purchase History"
  end

  test "complete profile management journey" do
    # 1. User signs in
    sign_in @user
    
    # 2. User views their profile
    visit profile_url(@user)
    assert_selector "h1", text: /🎯/
    
    # 3. User edits their profile
    click_on "Edit Profile"
    assert_selector "h2", text: "Modifier mon profil"
    
    # 4. User updates their information
    fill_in "Username", with: "NewUsername"
    click_button "Mettre à jour"
    assert_text "mis à jour avec succès"
    
    # 5. User views their updated profile
    visit profile_url(@user)
    assert_text "NewUsername"
    
    # 6. User checks their statistics
    assert_text "Statistics"
    assert_text "Games played"
    assert_text "Points earned"
    assert_text "Badges earned"
  end

  test "complete leaderboard journey" do
    # 1. User signs in
    sign_in @user
    
    # 2. User plays games to earn points
    @playlist.videos.each do |video|
      game = Game.create!(user: @user, playlist: @playlist)
      Swipe.create!(user: @user, video: video, game: game, action: 'like', liked: true, playlist: @playlist)
    end
    
    # 3. User checks scores
    visit scores_url
    assert_selector "h1", text: "Scores"
    
    # 4. User views leaderboard
    click_on "Leaderboard"
    assert_text "Leaderboard"
    
    # 5. User checks different score types
    click_on "Total Scores"
    assert_text "Total Scores"
    
    click_on "Engager Scores"
    assert_text "Engager Scores"
    
    click_on "Critic Scores"
    assert_text "Critic Scores"
    
    # 6. User views their ranking
    click_on "Your Ranking"
    assert_text "Your Ranking"
  end

  test "complete navigation journey" do
    # 1. User visits the site
    visit root_url
    
    # 2. User navigates through all main sections
    click_on "Playlists"
    assert_current_path playlists_path
    
    click_on "Badges"
    assert_current_path badges_path
    
    click_on "Rewards"
    assert_current_path rewards_path
    
    click_on "Store"
    assert_current_path store_path
    
    click_on "Scores"
    assert_current_path scores_path
    
    # 3. User signs in
    sign_in @user
    
    # 4. User navigates to profile
    click_on "Profile"
    assert_current_path profile_path(@user)
    
    # 5. User navigates back to home
    click_on "Home"
    assert_current_path root_path
  end

  test "complete error handling journey" do
    # 1. User tries to access protected content without authentication
    visit new_playlist_path
    assert_current_path new_user_session_path
    
    # 2. User tries to access non-existent content
    visit playlist_path(99999)
    assert_response :not_found
    
    # 3. User signs in
    sign_in @user
    
    # 4. User tries to access other user's content
    other_user = users(:two)
    visit edit_profile_path(other_user)
    assert_response :forbidden
    
    # 5. User tries to unlock content with insufficient points
    @user.update!(game_points: 100)
    visit playlist_path(@premium_playlist)
    click_button "Unlock"
    assert_text "Insufficient points"
  end

  test "complete responsive design journey" do
    # 1. User visits on desktop
    visit root_url
    assert_selector "h1", text: "Welcome"
    
    # 2. User resizes to mobile (simulate)
    page.driver.browser.manage.window.resize_to(375, 667)
    
    # 3. User navigates on mobile
    click_on "Menu"
    assert_text "Navigation"
    
    # 4. User uses mobile features
    click_on "Playlists"
    assert_current_path playlists_path
    
    # 5. User resizes back to desktop
    page.driver.browser.manage.window.resize_to(1920, 1080)
    
    # 6. User continues on desktop
    assert_selector "h1", text: "Playlists"
  end
end
