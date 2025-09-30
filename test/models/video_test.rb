require "test_helper"

class VideoTest < ActiveSupport::TestCase
  def setup
    @playlist = playlists(:one)
    @video = videos(:one)
  end

  test "should be valid" do
    assert @video.valid?
  end

  test "title should be present" do
    @video.title = "   "
    assert_not @video.valid?
  end

  test "youtube_id should be present" do
    @video.youtube_id = "   "
    assert_not @video.valid?
  end

  test "youtube_id should be unique within playlist" do
    duplicate_video = @video.dup
    duplicate_video.youtube_id = @video.youtube_id
    @video.save
    assert_not duplicate_video.valid?
  end

  test "should belong to playlist" do
    assert_respond_to @video, :playlist
  end

  test "should have many swipes" do
    assert_respond_to @video, :swipes
  end

  test "points should calculate based on likes" do
    # Clear existing swipes for this video
    @video.swipes.destroy_all
    
    user = users(:one)
    game = Game.create!(user: user, playlist: @playlist)
    
    # Create like swipes
    Swipe.create!(user: user, video: @video, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: users(:two), video: @video, game: Game.create!(user: users(:two), playlist: @playlist), action: 'like', liked: true, playlist: @playlist)
    
    # Points should be 4 (2 likes * 2 points each)
    assert_equal 4, @video.points
  end

  test "points should return 0 when no likes" do
    # Clear existing swipes for this video
    @video.swipes.destroy_all
    assert_equal 0, @video.points
  end

  test "points should not count dislikes" do
    # Clear existing swipes for this video
    @video.swipes.destroy_all
    
    user = users(:one)
    game = Game.create!(user: user, playlist: @playlist)
    
    # Create dislike swipe
    Swipe.create!(user: user, video: @video, game: game, action: 'dislike', liked: false, playlist: @playlist)
    
    # Points should still be 0
    assert_equal 0, @video.points
  end
end
