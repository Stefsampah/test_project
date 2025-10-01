require "test_helper"

class BadgesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @badge = badges(:one) # Utiliser la fixture existante
  end

  test "should get index" do
    get badges_url
    assert_response :success
  end

  test "should get index when authenticated" do
    sign_in @user
    get badges_url
    assert_response :success
  end

  test "should show badge" do
    get badge_url(@badge)
    assert_redirected_to new_user_session_path
  end

  test "should show badge when authenticated" do
    sign_in @user
    get badge_url(@badge)
    assert_response :success
  end

  # Routes for new, create, edit, update, destroy are not available
  # Only index and show routes exist for badges

  test "should show competitor badges" do
    get badges_url, params: { type: 'competitor' }
    assert_redirected_to new_user_session_path
  end

  test "should show engager badges" do
    get badges_url, params: { type: 'engager' }
    assert_redirected_to new_user_session_path
  end

  test "should show critic badges" do
    get badges_url, params: { type: 'critic' }
    assert_redirected_to new_user_session_path
  end

  test "should show challenger badges" do
    get badges_url, params: { type: 'challenger' }
    assert_redirected_to new_user_session_path
  end

  test "should handle invalid badge type" do
    get badges_url, params: { type: 'invalid' }
    assert_redirected_to new_user_session_path
  end

  test "should show user badges when authenticated" do
    sign_in @user
    get badges_url, params: { user_id: @user.id }
    assert_response :success
  end

  test "should show all badges when no user specified" do
    get badges_url
    assert_redirected_to new_user_session_path
  end
end
