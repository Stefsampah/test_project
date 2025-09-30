require "test_helper"

class GameTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @game = Game.new(user: @user, playlist: @playlist)
  end

  test "should be valid" do
    assert @game.valid?
  end

  test "user should be present" do
    @game.user = nil
    assert_not @game.valid?
  end

  test "playlist should be present" do
    @game.playlist = nil
    assert_not @game.valid?
  end

  test "should belong to user" do
    assert_respond_to @game, :user
  end

  test "should belong to playlist" do
    assert_respond_to @game, :playlist
  end

  test "should have many swipes" do
    assert_respond_to @game, :swipes
  end

  test "should have many videos through playlist" do
    assert_respond_to @game, :videos
  end

  test "current_video should return first unswiped video" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Initially, current_video should be one of the videos
    assert_includes [video1, video2], @game.current_video
    
    # After swiping first video, current_video should be the other
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    assert_equal video2, @game.current_video
  end

  test "next_video should return first unswiped video" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Initially, next_video should be one of the videos
    assert_includes [video1, video2], @game.next_video
    
    # After swiping first video, next_video should be the other
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    assert_equal video2, @game.next_video
  end

  test "completed? should return false when not all videos swiped" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Swipe only one video
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    
    assert_not @game.completed?
  end

  test "completed? should return true when all videos swiped" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Swipe all videos
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: @game, action: 'dislike', liked: false, playlist: @playlist)
    
    assert @game.completed?
  end

  test "swipe should create a new swipe record" do
    @game.save!
    video = videos(:one)
    
    assert_difference 'Swipe.count', 1 do
      @game.swipe('like')
    end
  end

  test "swipe should return next video" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    next_video = @game.swipe('like')
    # Should return the other video (not the one that was swiped)
    assert_includes [video1, video2], next_video
    assert_not_equal @game.current_video, next_video
  end

  test "swipe should not work when game is completed" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Complete the game
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: @game, action: 'dislike', liked: false, playlist: @playlist)
    
    # Try to swipe again
    assert_nil @game.swipe('like')
  end

  test "score should calculate based on swipes" do
    @game.save!
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Create swipes
    Swipe.create!(user: @user, video: video1, game: @game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: @game, action: 'dislike', liked: false, playlist: @playlist)
    
    # Score should be 3 (2 for like + 1 for dislike)
    assert_equal 3, @game.score
  end

  test "score should return 0 when no swipes" do
    @game.save!
    assert_equal 0, @game.score
  end
end
