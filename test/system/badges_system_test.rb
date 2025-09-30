require "application_system_test_case"

class BadgesSystemTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
    @badge = Badge.create!(
      name: "Test Badge",
      badge_type: "competitor",
      level: "bronze",
      points_required: 100,
      description: "Test badge description"
    )
  end

  test "visiting the badges index" do
    visit badges_url
    assert_selector "h1", text: "Badges"
  end

  test "viewing a specific badge" do
    visit badge_url(@badge)
    assert_selector "h1", text: @badge.name
    assert_text @badge.description
  end

  test "filtering badges by type" do
    visit badges_url
    
    # Test competitor badges filter
    click_on "Competitor"
    assert_selector "h2", text: "Competitor Badges"
    
    # Test engager badges filter
    click_on "Engager"
    assert_selector "h2", text: "Engager Badges"
    
    # Test critic badges filter
    click_on "Critic"
    assert_selector "h2", text: "Critic Badges"
    
    # Test challenger badges filter
    click_on "Challenger"
    assert_selector "h2", text: "Challenger Badges"
  end

  test "viewing badge requirements" do
    visit badge_url(@badge)
    assert_text "Points required: #{@badge.points_required}"
    assert_text "Level: #{@badge.level.capitalize}"
  end

  test "viewing badge levels progression" do
    # Create badges of different levels
    bronze_badge = Badge.create!(
      name: "Bronze Badge",
      badge_type: "competitor",
      level: "bronze",
      points_required: 100,
      description: "Bronze level badge"
    )
    
    silver_badge = Badge.create!(
      name: "Silver Badge",
      badge_type: "competitor",
      level: "silver",
      points_required: 200,
      description: "Silver level badge"
    )
    
    gold_badge = Badge.create!(
      name: "Gold Badge",
      badge_type: "competitor",
      level: "gold",
      points_required: 300,
      description: "Gold level badge"
    )
    
    visit badge_url(bronze_badge)
    assert_text "Next level: Silver"
    
    visit badge_url(silver_badge)
    assert_text "Previous level: Bronze"
    assert_text "Next level: Gold"
    
    visit badge_url(gold_badge)
    assert_text "Previous level: Silver"
    assert_text "Maximum level reached"
  end

  test "viewing user badges when authenticated" do
    sign_in @user
    visit badges_url
    assert_selector "h2", text: "Your Badges"
  end

  test "viewing badge progress" do
    sign_in @user
    visit badge_url(@badge)
    
    # Should show progress towards badge
    assert_text "Progress"
    assert_text "0 / #{@badge.points_required} points"
  end

  test "viewing earned badges" do
    sign_in @user
    
    # Create a user badge
    user_badge = UserBadge.create!(
      user: @user,
      badge: @badge,
      earned_at: Time.current
    )
    
    visit badges_url
    assert_selector "h2", text: "Your Badges"
    assert_text @badge.name
    assert_text "Earned"
  end

  test "viewing badge rewards" do
    # Create a badge with rewards
    reward_badge = Badge.create!(
      name: "Reward Badge",
      badge_type: "competitor",
      level: "gold",
      points_required: 500,
      description: "Badge with rewards",
      reward_type: "premium",
      reward_description: "Unlock premium content"
    )
    
    visit badge_url(reward_badge)
    assert_text "Reward: #{reward_badge.reward_description}"
  end

  test "searching badges" do
    visit badges_url
    
    # Test search functionality
    fill_in "search", with: "Test"
    click_button "Search"
    
    assert_text @badge.name
  end

  test "viewing badge statistics" do
    visit badge_url(@badge)
    
    # Should show badge statistics
    assert_text "Statistics"
    assert_text "Total earned: 0"
  end

  test "viewing badge leaderboard" do
    visit badges_url
    click_on "Leaderboard"
    
    assert_selector "h1", text: "Badge Leaderboard"
  end

  test "viewing badge categories" do
    visit badges_url
    
    # Should show different badge categories
    assert_selector "div", text: "Competitor"
    assert_selector "div", text: "Engager"
    assert_selector "div", text: "Critic"
    assert_selector "div", text: "Challenger"
  end

  test "viewing badge details" do
    visit badge_url(@badge)
    
    # Should show all badge details
    assert_text @badge.name
    assert_text @badge.description
    assert_text @badge.badge_type.capitalize
    assert_text @badge.level.capitalize
    assert_text @badge.points_required.to_s
  end

  test "viewing badge requirements breakdown" do
    visit badge_url(@badge)
    
    # Should show requirements breakdown
    assert_text "Requirements"
    assert_text "Points: #{@badge.points_required}"
  end

  test "viewing badge unlock conditions" do
    visit badge_url(@badge)
    
    # Should show unlock conditions
    assert_text "Unlock Conditions"
  end

  test "viewing badge related content" do
    visit badge_url(@badge)
    
    # Should show related content
    assert_text "Related Content"
  end

  test "viewing badge achievements" do
    sign_in @user
    visit badge_url(@badge)
    
    # Should show achievements related to badge
    assert_text "Achievements"
  end

  test "viewing badge progress tracking" do
    sign_in @user
    visit badge_url(@badge)
    
    # Should show progress tracking
    assert_text "Progress Tracking"
    assert_text "0%"
  end

  test "viewing badge milestones" do
    visit badge_url(@badge)
    
    # Should show milestones
    assert_text "Milestones"
  end

  test "viewing badge rewards preview" do
    # Create a badge with rewards
    reward_badge = Badge.create!(
      name: "Reward Badge",
      badge_type: "competitor",
      level: "gold",
      points_required: 500,
      description: "Badge with rewards",
      reward_type: "premium",
      reward_description: "Unlock premium content"
    )
    
    visit badge_url(reward_badge)
    
    # Should show rewards preview
    assert_text "Rewards Preview"
    assert_text reward_badge.reward_description
  end
end
