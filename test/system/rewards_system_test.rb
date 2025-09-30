require "application_system_test_case"

class RewardsSystemTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
    @reward = Reward.create!(
      user: @user,
      badge_type: "competitor",
      quantity_required: 1,
      reward_type: "challenge",
      reward_description: "Test reward description",
      content_type: "playlist_exclusive"
    )
  end

  test "visiting the rewards index" do
    visit rewards_url
    assert_selector "h1", text: "Rewards"
  end

  test "viewing a specific reward" do
    visit reward_url(@reward)
    assert_selector "h1", text: "Reward Details"
    assert_text @reward.reward_description
  end

  test "filtering rewards by type" do
    visit rewards_url
    
    # Test challenge rewards filter
    click_on "Challenge"
    assert_selector "h2", text: "Challenge Rewards"
    
    # Test exclusif rewards filter
    click_on "Exclusif"
    assert_selector "h2", text: "Exclusif Rewards"
    
    # Test premium rewards filter
    click_on "Premium"
    assert_selector "h2", text: "Premium Rewards"
    
    # Test ultime rewards filter
    click_on "Ultime"
    assert_selector "h2", text: "Ultime Rewards"
  end

  test "viewing reward requirements" do
    visit reward_url(@reward)
    assert_text "Badge type: #{@reward.badge_type.capitalize}"
    assert_text "Quantity required: #{@reward.quantity_required}"
    assert_text "Content type: #{@reward.content_type.humanize}"
  end

  test "viewing user rewards when authenticated" do
    sign_in @user
    visit rewards_url
    assert_selector "h2", text: "Your Rewards"
  end

  test "viewing available rewards" do
    sign_in @user
    visit rewards_url
    
    # Should show available rewards
    assert_selector "h2", text: "Available Rewards"
  end

  test "viewing earned rewards" do
    sign_in @user
    
    # Create a reward directly (no DigitalReward model exists)
    @reward.update!(unlocked: true)
    
    visit rewards_url
    assert_selector "h2", text: "Your Rewards"
    assert_text @reward.reward_description
  end

  test "viewing reward content types" do
    visit rewards_url
    
    # Should show different content types
    assert_selector "div", text: "Playlist Exclusive"
    assert_selector "div", text: "Playlist Acoustic"
    assert_selector "div", text: "Podcast Exclusive"
  end

  test "viewing reward badges" do
    visit rewards_url
    
    # Should show different badge types
    assert_selector "div", text: "Competitor"
    assert_selector "div", text: "Engager"
    assert_selector "div", text: "Critic"
    assert_selector "div", text: "Challenger"
  end

  test "searching rewards" do
    visit rewards_url
    
    # Test search functionality
    fill_in "search", with: "Test"
    click_button "Search"
    
    assert_text @reward.reward_description
  end

  test "viewing reward statistics" do
    visit reward_url(@reward)
    
    # Should show reward statistics
    assert_text "Statistics"
    assert_text "Total unlocked: 0"
  end

  test "viewing reward leaderboard" do
    visit rewards_url
    click_on "Leaderboard"
    
    assert_selector "h1", text: "Reward Leaderboard"
  end

  test "viewing reward details" do
    visit reward_url(@reward)
    
    # Should show all reward details
    assert_text @reward.reward_description
    assert_text @reward.badge_type.capitalize
    assert_text @reward.reward_type.capitalize
    assert_text @reward.content_type.humanize
    assert_text @reward.quantity_required.to_s
  end

  test "viewing reward unlock conditions" do
    visit reward_url(@reward)
    
    # Should show unlock conditions
    assert_text "Unlock Conditions"
    assert_text "Badge type: #{@reward.badge_type.capitalize}"
    assert_text "Quantity: #{@reward.quantity_required}"
  end

  test "viewing reward content preview" do
    visit reward_url(@reward)
    
    # Should show content preview
    assert_text "Content Preview"
  end

  test "viewing reward achievements" do
    sign_in @user
    visit reward_url(@reward)
    
    # Should show achievements related to reward
    assert_text "Achievements"
  end

  test "viewing reward progress tracking" do
    sign_in @user
    visit reward_url(@reward)
    
    # Should show progress tracking
    assert_text "Progress Tracking"
  end

  test "viewing reward milestones" do
    visit reward_url(@reward)
    
    # Should show milestones
    assert_text "Milestones"
  end

  test "viewing reward content types breakdown" do
    visit rewards_url
    
    # Should show content types breakdown
    assert_text "Content Types"
    assert_text "Playlist Exclusive"
    assert_text "Playlist Acoustic"
    assert_text "Podcast Exclusive"
    assert_text "Documentary"
    assert_text "Backstage Video"
  end

  test "viewing reward badge types breakdown" do
    visit rewards_url
    
    # Should show badge types breakdown
    assert_text "Badge Types"
    assert_text "Competitor"
    assert_text "Engager"
    assert_text "Critic"
    assert_text "Challenger"
  end

  test "viewing reward rarity levels" do
    visit rewards_url
    
    # Should show rarity levels
    assert_text "Rarity Levels"
    assert_text "Challenge"
    assert_text "Exclusif"
    assert_text "Premium"
    assert_text "Ultime"
  end

  test "viewing reward unlock progress" do
    sign_in @user
    visit reward_url(@reward)
    
    # Should show unlock progress
    assert_text "Unlock Progress"
    assert_text "0 / #{@reward.quantity_required}"
  end

  test "viewing reward content access" do
    sign_in @user
    
    # Unlock the reward directly
    @reward.update!(unlocked: true)
    
    visit reward_url(@reward)
    
    # Should show content access
    assert_text "Content Access"
  end

  test "viewing reward content download" do
    sign_in @user
    
    # Unlock the reward directly
    @reward.update!(unlocked: true)
    
    visit reward_url(@reward)
    
    # Should show download option
    assert_text "Download"
  end

  test "viewing reward content streaming" do
    sign_in @user
    
    # Unlock the reward directly
    @reward.update!(unlocked: true)
    
    visit reward_url(@reward)
    
    # Should show streaming option
    assert_text "Stream"
  end

  test "viewing reward content sharing" do
    sign_in @user
    
    # Unlock the reward directly
    @reward.update!(unlocked: true)
    
    visit reward_url(@reward)
    
    # Should show sharing option
    assert_text "Share"
  end
end
