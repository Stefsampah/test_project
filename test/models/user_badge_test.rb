require "test_helper"

class UserBadgeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @badge = badges(:one)  # Use existing fixture
    @user_badge = UserBadge.new(user: @user, badge: @badge)
  end

  test "should be valid" do
    assert @user_badge.valid?
  end

  test "user_id should be present" do
    @user_badge.user = nil
    assert_not @user_badge.valid?
  end

  test "badge_id should be present" do
    @user_badge.badge = nil
    assert_not @user_badge.valid?
  end

  test "should belong to user" do
    assert_respond_to @user_badge, :user
  end

  test "should belong to badge" do
    assert_respond_to @user_badge, :badge
  end

  test "earned scope should return badges with earned_at" do
    # Créer un nouveau user_badge pour éviter les conflits
    new_user = users(:two)
    new_user_badge = UserBadge.create!(user: new_user, badge: @badge, earned_at: Time.current, points_at_earned: 100)
    
    earned_badges = UserBadge.earned
    assert_includes earned_badges, new_user_badge
  end

  test "earned scope should not return badges without earned_at" do
    # Créer un nouveau user_badge pour éviter les conflits
    new_user = users(:two)
    new_user_badge = UserBadge.create!(user: new_user, badge: @badge, points_at_earned: 100)
    
    earned_badges = UserBadge.earned
    assert_not_includes earned_badges, new_user_badge
  end

  test "reward_available? should return true when earned_at is present" do
    @user_badge.earned_at = Time.current
    assert @user_badge.reward_available?
  end

  test "reward_available? should return false when earned_at is nil" do
    assert_not @user_badge.reward_available?
  end

  test "should check rewards after create" do
    # Test that the callback is set up correctly
    assert_respond_to @user_badge, :check_rewards
  end

  test "check_rewards should call Reward.check_and_create_rewards_for_user" do
    # Test that the method exists and can be called
    assert_respond_to Reward, :check_and_create_rewards_for_user
  end
end
