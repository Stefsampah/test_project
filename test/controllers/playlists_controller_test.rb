require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @premium_playlist = playlists(:two)
  end

  test "should get index" do
    get playlists_url
    assert_response :success
  end

  test "should get show" do
    get playlist_url(@playlist)
    assert_response :success
  end

  test "should get show for premium playlist" do
    get playlist_url(@premium_playlist)
    assert_response :success
  end

  # Routes for new, create, edit, update, destroy are not available
  # Only index and show routes exist for playlists

  test "should show premium playlist to authenticated user" do
    sign_in @user
    get playlist_url(@premium_playlist)
    assert_response :success
  end

  test "should show premium playlist to non-authenticated user" do
    get playlist_url(@premium_playlist)
    assert_response :success
  end

  test "should handle playlist with videos" do
    get playlist_url(@playlist)
    assert_response :success
    assert_select "h1", text: @playlist.title
  end

  test "should handle playlist without videos" do
    empty_playlist = Playlist.create!(
      title: "Empty Playlist",
      description: "No videos",
      category: "Test"
    )
    get playlist_url(empty_playlist)
    assert_response :success
  end
end
