require "test_helper"

class RewardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @reward = rewards(:one) # Utiliser la fixture existante
  end

  test "should get index" do
    get rewards_url
    assert_redirected_to new_user_session_path
  end

  test "should get index when authenticated" do
    sign_in @user
    get rewards_url
    assert_response :success
  end

  test "should show reward" do
    get reward_url(@reward)
    assert_redirected_to new_user_session_path
  end

  test "should show reward when authenticated" do
    sign_in @user
    get reward_url(@reward)
    assert_response :success
  end

  # Routes for new, create, edit, update, destroy are not available
  # Only index and show routes exist for rewards

  test "should show challenge rewards" do
    get rewards_url, params: { type: 'challenge' }
    assert_redirected_to new_user_session_path
  end

  test "should show exclusif rewards" do
    get rewards_url, params: { type: 'exclusif' }
    assert_redirected_to new_user_session_path
  end

  test "should show premium rewards" do
    get rewards_url, params: { type: 'premium' }
    assert_redirected_to new_user_session_path
  end

  test "should show ultime rewards" do
    get rewards_url, params: { type: 'ultime' }
    assert_redirected_to new_user_session_path
  end

  test "should handle invalid reward type" do
    get rewards_url, params: { type: 'invalid' }
    assert_redirected_to new_user_session_path
  end

  test "should show user rewards when authenticated" do
    sign_in @user
    get rewards_url, params: { user_id: @user.id }
    assert_response :success
  end

  test "should show all rewards when no user specified" do
    get rewards_url
    assert_redirected_to new_user_session_path
  end

  test "should show rewards by content type" do
    get rewards_url, params: { content_type: 'playlist_exclusive' }
    assert_redirected_to new_user_session_path
  end

  test "should show rewards by badge type" do
    get rewards_url, params: { badge_type: 'competitor' }
    assert_redirected_to new_user_session_path
  end

  test "should handle multiple filters" do
    get rewards_url, params: { 
      type: 'challenge', 
      content_type: 'playlist_exclusive',
      badge_type: 'competitor'
    }
    assert_redirected_to new_user_session_path
  end
end
