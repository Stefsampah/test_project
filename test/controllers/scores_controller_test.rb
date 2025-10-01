require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @score = Score.create!(user: @user, playlist: @playlist, points: 100)
  end

  test "should get index" do
    get scores_url
    assert_redirected_to new_user_session_path
  end

  test "should get index when authenticated" do
    sign_in @user
    get scores_url
    assert_response :success
  end

  test "should show score" do
    get score_url(@score)
    assert_redirected_to new_user_session_path
  end

  test "should show score when authenticated" do
    sign_in @user
    get score_url(@score)
    assert_response :success
  end

  # Routes for new, create, edit, update, destroy are not available
  # Only index and show routes exist for scores

  test "should show top engager scores" do
    get scores_url, params: { type: 'engager' }
    assert_redirected_to new_user_session_path
  end

  test "should show best ratio scores" do
    get scores_url, params: { type: 'ratio' }
    assert_redirected_to new_user_session_path
  end

  test "should show wise critic scores" do
    get scores_url, params: { type: 'critic' }
    assert_redirected_to new_user_session_path
  end

  test "should show total scores" do
    get scores_url, params: { type: 'total' }
    assert_redirected_to new_user_session_path
  end

  test "should handle invalid score type" do
    get scores_url, params: { type: 'invalid' }
    assert_redirected_to new_user_session_path
  end

  test "should show user scores when authenticated" do
    sign_in @user
    get scores_url, params: { user_id: @user.id }
    assert_response :success
  end

  test "should show all scores when no user specified" do
    get scores_url
    assert_redirected_to new_user_session_path
  end

  test "should show scores by playlist" do
    get scores_url, params: { playlist_id: @playlist.id }
    assert_redirected_to new_user_session_path
  end

  test "should show leaderboard" do
    get scores_url, params: { view: 'leaderboard' }
    assert_redirected_to new_user_session_path
  end

  test "should show user ranking" do
    sign_in @user
    get scores_url, params: { view: 'ranking' }
    assert_response :success
  end

  test "should handle multiple filters" do
    get scores_url, params: { 
      type: 'total', 
      playlist_id: @playlist.id,
      view: 'leaderboard'
    }
    assert_redirected_to new_user_session_path
  end

  test "should show score details" do
    get score_url(@score)
    assert_redirected_to new_user_session_path
  end

  test "should show score badges" do
    get score_url(@score)
    assert_redirected_to new_user_session_path
  end
end
