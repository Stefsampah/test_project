require "application_system_test_case"

class PremiumPlaylistsTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
    @premium_playlist = playlists(:two) # Premium playlist
    @regular_playlist = playlists(:one) # Regular playlist
  end

  test "viewing premium playlist without authentication" do
    visit playlist_url(@premium_playlist)
    
    # Should show premium playlist but with lock
    assert_selector "h1", text: @premium_playlist.title
    assert_text "Premium"
    assert_text "500 points required"
    assert_selector "button", text: "Unlock"
  end

  test "viewing premium playlist with authentication but insufficient points" do
    sign_in @user
    @user.update!(game_points: 100) # Not enough points
    
    visit playlist_url(@premium_playlist)
    
    # Should show premium playlist with lock
    assert_selector "h1", text: @premium_playlist.title
    assert_text "Premium"
    assert_text "500 points required"
    assert_text "You have 100 points"
    assert_selector "button", text: "Unlock"
  end

  test "viewing premium playlist with authentication and sufficient points" do
    sign_in @user
    @user.update!(game_points: 1000) # Enough points
    
    visit playlist_url(@premium_playlist)
    
    # Should show premium playlist with unlock option
    assert_selector "h1", text: @premium_playlist.title
    assert_text "Premium"
    assert_text "500 points required"
    assert_text "You have 1000 points"
    assert_selector "button", text: "Unlock"
  end

  test "unlocking premium playlist with sufficient points" do
    sign_in @user
    @user.update!(game_points: 1000) # Enough points
    
    visit playlist_url(@premium_playlist)
    
    # Click unlock button
    click_button "Unlock"
    
    # Should unlock the playlist
    assert_text "Playlist unlocked successfully"
    assert_text "You can now access this premium content"
    
    # Should deduct points
    @user.reload
    assert_equal 500, @user.game_points
  end

  test "unlocking premium playlist with insufficient points" do
    sign_in @user
    @user.update!(game_points: 100) # Not enough points
    
    visit playlist_url(@premium_playlist)
    
    # Click unlock button
    click_button "Unlock"
    
    # Should show error
    assert_text "Insufficient points"
    assert_text "You need 400 more points"
    
    # Should not deduct points
    @user.reload
    assert_equal 100, @user.game_points
  end

  test "viewing unlocked premium playlist" do
    sign_in @user
    @user.update!(game_points: 1000)
    
    # Unlock the playlist
    UserPlaylistUnlock.create!(user: @user, playlist: @premium_playlist)
    
    visit playlist_url(@premium_playlist)
    
    # Should show unlocked content
    assert_selector "h1", text: @premium_playlist.title
    assert_text "Unlocked"
    assert_text "Premium Content"
    assert_selector "button", text: "Start Game"
  end

  test "viewing premium playlist in index" do
    visit playlists_url
    
    # Should show premium playlists with lock icon
    assert_selector "div", text: @premium_playlist.title
    assert_text "Premium"
    assert_text "500 points"
  end

  test "filtering premium playlists" do
    visit playlists_url
    
    # Filter by premium
    click_on "Premium"
    
    # Should show only premium playlists
    assert_selector "div", text: @premium_playlist.title
    assert_text "Premium"
  end

  test "viewing premium playlist details" do
    visit playlist_url(@premium_playlist)
    
    # Should show premium details
    assert_text "Premium Playlist"
    assert_text "500 points required"
    assert_text "Exclusive content"
    assert_text "High quality videos"
  end

  test "viewing premium playlist benefits" do
    visit playlist_url(@premium_playlist)
    
    # Should show benefits
    assert_text "Benefits"
    assert_text "Exclusive access"
    assert_text "Premium quality"
    assert_text "Special rewards"
  end

  test "viewing premium playlist requirements" do
    visit playlist_url(@premium_playlist)
    
    # Should show requirements
    assert_text "Requirements"
    assert_text "500 points"
    assert_text "Account required"
  end

  test "viewing premium playlist preview" do
    visit playlist_url(@premium_playlist)
    
    # Should show preview
    assert_text "Preview"
    assert_text "Sample content"
  end

  test "viewing premium playlist reviews" do
    visit playlist_url(@premium_playlist)
    
    # Should show reviews
    assert_text "Reviews"
    assert_text "User ratings"
  end

  test "viewing premium playlist recommendations" do
    visit playlist_url(@premium_playlist)
    
    # Should show recommendations
    assert_text "Recommendations"
    assert_text "Similar playlists"
  end

  test "viewing premium playlist sharing" do
    visit playlist_url(@premium_playlist)
    
    # Should show sharing options
    assert_text "Share"
    assert_selector "button", text: "Share"
  end

  test "viewing premium playlist favorites" do
    sign_in @user
    visit playlist_url(@premium_playlist)
    
    # Should show favorite option
    assert_text "Add to Favorites"
    assert_selector "button", text: "Add to Favorites"
  end

  test "viewing premium playlist playlist" do
    visit playlist_url(@premium_playlist)
    
    # Should show playlist content
    assert_text "Playlist Content"
    assert_text "Videos"
  end

  test "viewing premium playlist statistics" do
    visit playlist_url(@premium_playlist)
    
    # Should show statistics
    assert_text "Statistics"
    assert_text "Total views"
    assert_text "Unlock rate"
  end

  test "viewing premium playlist leaderboard" do
    visit playlist_url(@premium_playlist)
    
    # Should show leaderboard
    assert_text "Leaderboard"
    assert_text "Top players"
  end

  test "viewing premium playlist achievements" do
    visit playlist_url(@premium_playlist)
    
    # Should show achievements
    assert_text "Achievements"
    assert_text "Available badges"
  end

  test "viewing premium playlist rewards" do
    visit playlist_url(@premium_playlist)
    
    # Should show rewards
    assert_text "Rewards"
    assert_text "Special rewards"
  end

  test "viewing premium playlist challenges" do
    visit playlist_url(@premium_playlist)
    
    # Should show challenges
    assert_text "Challenges"
    assert_text "Special challenges"
  end

  test "viewing premium playlist events" do
    visit playlist_url(@premium_playlist)
    
    # Should show events
    assert_text "Events"
    assert_text "Special events"
  end

  test "viewing premium playlist community" do
    visit playlist_url(@premium_playlist)
    
    # Should show community
    assert_text "Community"
    assert_text "Premium members"
  end

  test "viewing premium playlist support" do
    visit playlist_url(@premium_playlist)
    
    # Should show support
    assert_text "Support"
    assert_text "Premium support"
  end
end
