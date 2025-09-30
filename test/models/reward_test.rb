require "test_helper"

class RewardTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @reward = Reward.new(
      user: @user,
      badge_type: "competitor",
      quantity_required: 1,
      reward_type: "challenge",
      reward_description: "Test reward description",
      content_type: "playlist_exclusive"
    )
  end

  test "should be valid" do
    assert @reward.valid?
  end

  test "badge_type should be present" do
    @reward.badge_type = "   "
    assert_not @reward.valid?
  end

  test "quantity_required should be present" do
    @reward.quantity_required = nil
    assert_not @reward.valid?
  end

  test "quantity_required should be greater than 0" do
    @reward.quantity_required = 0
    assert_not @reward.valid?
    
    @reward.quantity_required = -1
    assert_not @reward.valid?
    
    @reward.quantity_required = 1
    assert @reward.valid?
  end

  test "reward_type should be present" do
    @reward.reward_type = "   "
    assert_not @reward.valid?
  end

  test "reward_type should be valid" do
    @reward.reward_type = "invalid"
    assert_not @reward.valid?
    
    %w[challenge exclusif premium ultime].each do |type|
      @reward.reward_type = type
      assert @reward.valid?, "#{type} should be valid"
    end
  end

  test "reward_description should be present" do
    @reward.reward_description = "   "
    assert_not @reward.valid?
  end

  test "content_type should be present" do
    @reward.content_type = "   "
    assert_not @reward.valid?
  end

  test "content_type should be valid" do
    @reward.content_type = "invalid"
    assert_not @reward.valid?
    
    %w[playlist_exclusive playlist_acoustic playlist_remix podcast_exclusive].each do |type|
      @reward.content_type = type
      assert @reward.valid?, "#{type} should be valid"
    end
  end

  test "should belong to user" do
    assert_respond_to @reward, :user
  end

  test "challenge? should return true for challenge rewards" do
    @reward.reward_type = "challenge"
    assert @reward.challenge?
  end

  test "exclusif? should return true for exclusif rewards" do
    @reward.reward_type = "exclusif"
    assert @reward.exclusif?
  end

  test "premium? should return true for premium rewards" do
    @reward.reward_type = "premium"
    assert @reward.premium?
  end

  test "ultime? should return true for ultime rewards" do
    @reward.reward_type = "ultime"
    assert @reward.ultime?
  end

  test "playlist_exclusive? should return true for playlist_exclusive content" do
    @reward.content_type = "playlist_exclusive"
    assert @reward.playlist_exclusive?
  end

  test "playlist_acoustic? should return true for playlist_acoustic content" do
    @reward.content_type = "playlist_acoustic"
    assert @reward.playlist_acoustic?
  end

  test "podcast_exclusive? should return true for podcast_exclusive content" do
    @reward.content_type = "podcast_exclusive"
    assert @reward.podcast_exclusive?
  end

  test "documentary? should return true for documentary content" do
    @reward.content_type = "documentary"
    assert @reward.documentary?
  end

  test "backstage_video? should return true for backstage_video content" do
    @reward.content_type = "backstage_video"
    assert @reward.backstage_video?
  end

  test "concert_footage? should return true for concert_footage content" do
    @reward.content_type = "concert_footage"
    assert @reward.concert_footage?
  end

  test "backstage_real? should return true for backstage_real content" do
    @reward.content_type = "backstage_real"
    assert @reward.backstage_real?
  end

  test "concert_invitation? should return true for concert_invitation content" do
    @reward.content_type = "concert_invitation"
    assert @reward.concert_invitation?
  end

  test "vip_experience? should return true for vip_experience content" do
    @reward.content_type = "vip_experience"
    assert @reward.vip_experience?
  end

  test "challenge_reward_playlist_1? should return true for challenge_reward_playlist_1 content" do
    @reward.content_type = "challenge_reward_playlist_1"
    assert @reward.challenge_reward_playlist_1?
  end

  test "challenge_reward_playlist_15? should return true for challenge_reward_playlist_15 content" do
    @reward.content_type = "challenge_reward_playlist_15"
    assert @reward.challenge_reward_playlist_15?
  end
end
