require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  def setup
    @playlist = playlists(:one)
  end

  test "should be valid" do
    assert @playlist.valid?
  end

  test "title should be present" do
    @playlist.title = "   "
    assert_not @playlist.valid?
  end

  test "description should be present" do
    @playlist.description = "   "
    assert_not @playlist.valid?
  end

  test "should have many scores" do
    assert_respond_to @playlist, :scores
  end

  test "should have many games" do
    assert_respond_to @playlist, :games
  end

  test "should have many videos" do
    assert_respond_to @playlist, :videos
  end

  test "should have many user_playlist_unlocks" do
    assert_respond_to @playlist, :user_playlist_unlocks
  end

  test "should have many unlocked_users" do
    assert_respond_to @playlist, :unlocked_users
  end

  test "should have many badge_playlist_unlocks" do
    assert_respond_to @playlist, :badge_playlist_unlocks
  end

  test "should have many unlocking_badges" do
    assert_respond_to @playlist, :unlocking_badges
  end

  test "premium? should return true for premium playlists" do
    premium_playlist = playlists(:two)
    assert premium_playlist.premium?
  end

  test "premium? should return false for non-premium playlists" do
    assert_not @playlist.premium?
  end

  test "points_required should return 500 for premium playlists" do
    premium_playlist = playlists(:two)
    assert_equal 500, premium_playlist.points_required
  end

  test "points_required should return 0 for non-premium playlists" do
    assert_equal 0, @playlist.points_required
  end

  test "first_thumbnail should return youtube_id of first video" do
    video = @playlist.videos.first
    if video
      assert_equal video.youtube_id, @playlist.first_thumbnail
    else
      assert_nil @playlist.first_thumbnail
    end
  end

  test "random_thumbnail should return first_thumbnail" do
    assert_equal @playlist.first_thumbnail, @playlist.random_thumbnail
  end

  test "thumbnail_url should return correct YouTube URL" do
    video = @playlist.videos.first
    if video
      expected_url = "https://img.youtube.com/vi/#{video.youtube_id}/maxresdefault.jpg"
      assert_equal expected_url, @playlist.thumbnail_url
    else
      expected_url = "https://img.youtube.com/vi/default/maxresdefault.jpg"
      assert_equal expected_url, @playlist.thumbnail_url
    end
  end

  test "consistent_thumbnail should return same value on multiple calls" do
    first_call = @playlist.consistent_thumbnail
    second_call = @playlist.consistent_thumbnail
    assert_equal first_call, second_call
  end

  test "consistent_thumbnail_url should return correct URL" do
    thumbnail_id = @playlist.consistent_thumbnail
    if thumbnail_id
      expected_url = "https://img.youtube.com/vi/#{thumbnail_id}/maxresdefault.jpg"
      assert_equal expected_url, @playlist.consistent_thumbnail_url
    else
      expected_url = "https://img.youtube.com/vi/default/maxresdefault.jpg"
      assert_equal expected_url, @playlist.consistent_thumbnail_url
    end
  end

  test "full_category/: should return category > subcategory when both category and subcategory present" do
    @playlist.category = "Pop"
    @playlist.subcategory = "Hits"
    assert_equal "Pop > Hits", @playlist.full_category
  end

  test "full_category should return category when only category present" do
    @playlist.category = "Pop"
    @playlist.subcategory = nil
    assert_equal "Pop", @playlist.full_category
  end

  test "full_category should return genre when category not present" do
    @playlist.category = nil
    @playlist.genre = "Rock"
    assert_equal "Rock", @playlist.full_category
  end
end
