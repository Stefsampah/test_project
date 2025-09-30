require "test_helper"

class BadgeTest < ActiveSupport::TestCase
  def setup
    @badge = Badge.new(
      name: "Test Badge",
      badge_type: "challenger",
      level: "bronze",
      points_required: 100,
      description: "Test badge description"
    )
  end

  test "should be valid" do
    assert @badge.valid?
  end

  test "name should be present" do
    @badge.name = "   "
    assert_not @badge.valid?
  end

  test "badge_type should be present" do
    @badge.badge_type = "   "
    assert_not @badge.valid?
  end

  test "badge_type should be valid" do
    @badge.badge_type = "invalid"
    assert_not @badge.valid?
    
    Badge::BADGE_TYPES.each do |type|
      @badge.badge_type = type
      assert @badge.valid?, "#{type} should be valid"
    end
  end

  test "level should be present" do
    @badge.level = "   "
    assert_not @badge.valid?
  end

  test "level should be valid" do
    @badge.level = "invalid"
    assert_not @badge.valid?
    
    Badge::LEVELS.each do |level|
      @badge.level = level
      assert @badge.valid?, "#{level} should be valid"
    end
  end

  test "points_required should be present" do
    @badge.points_required = nil
    assert_not @badge.valid?
  end

  test "points_required should be greater than 0" do
    @badge.points_required = 0
    assert_not @badge.valid?
    
    @badge.points_required = -1
    assert_not @badge.valid?
    
    @badge.points_required = 1
    assert @badge.valid?
  end

  test "badge_type should be unique per level" do
    @badge.save!
    
    duplicate_badge = Badge.new(
      name: "Duplicate Badge",
      badge_type: "competitor",
      level: "bronze",
      points_required: 200,
      description: "Duplicate badge description"
    )
    assert_not duplicate_badge.valid?
  end

  test "should have many user_badges" do
    assert_respond_to @badge, :user_badges
  end

  test "should have many users through user_badges" do
    assert_respond_to @badge, :users
  end

  test "should have many badge_playlist_unlocks" do
    assert_respond_to @badge, :badge_playlist_unlocks
  end

  test "should have many exclusive_playlists" do
    assert_respond_to @badge, :exclusive_playlists
  end

  test "competitor_badges should return competitor badges ordered by points" do
    badges = Badge.competitor_badges
    assert badges.is_a?(ActiveRecord::Relation)
    
    if badges.count > 1
      assert badges.first.points_required <= badges.second.points_required
    end
  end

  test "engager_badges should return engager badges ordered by points" do
    badges = Badge.engager_badges
    assert badges.is_a?(ActiveRecord::Relation)
    
    if badges.count > 1
      assert badges.first.points_required <= badges.second.points_required
    end
  end

  test "critic_badges should return critic badges ordered by points" do
    badges = Badge.critic_badges
    assert badges.is_a?(ActiveRecord::Relation)
    
    if badges.count > 1
      assert badges.first.points_required <= badges.second.points_required
    end
  end

  test "challenger_badges should return challenger badges ordered by points" do
    badges = Badge.challenger_badges
    assert badges.is_a?(ActiveRecord::Relation)
    
    if badges.count > 1
      assert badges.first.points_required <= badges.second.points_required
    end
  end

  test "next_level should return next level badge" do
    bronze_badge = Badge.new(badge_type: "challenger", level: "bronze", points_required: 100, name: "Bronze Challenger", description: "Bronze badge")
    silver_badge = Badge.new(badge_type: "challenger", level: "silver", points_required: 200, name: "Silver Challenger", description: "Silver badge")
    
    bronze_badge.save!
    silver_badge.save!
    
    assert_equal silver_badge, bronze_badge.next_level
  end

  test "next_level should return nil for gold level" do
    gold_badge = Badge.new(badge_type: "challenger", level: "gold", points_required: 300, name: "Gold Challenger", description: "Gold badge")
    gold_badge.save!
    
    assert_nil gold_badge.next_level
  end

  test "previous_level should return previous level badge" do
    bronze_badge = Badge.new(badge_type: "challenger", level: "bronze", points_required: 100, name: "Bronze Challenger", description: "Bronze badge")
    silver_badge = Badge.new(badge_type: "challenger", level: "silver", points_required: 200, name: "Silver Challenger", description: "Silver badge")
    
    bronze_badge.save!
    silver_badge.save!
    
    assert_equal bronze_badge, silver_badge.previous_level
  end

  test "previous_level should return nil for bronze level" do
    bronze_badge = Badge.new(badge_type: "challenger", level: "bronze", points_required: 100, name: "Bronze Challenger", description: "Bronze badge")
    bronze_badge.save!
    
    assert_nil bronze_badge.previous_level
  end
end
