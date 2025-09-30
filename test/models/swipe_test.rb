require "test_helper"

class SwipeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @game = Game.create!(user: @user, playlist: @playlist)
    @video = videos(:one)
    @swipe = Swipe.new(user: @user, video: @video, game: @game, action: 'like', liked: true, playlist: @playlist)
  end

  test "should be valid" do
    assert @swipe.valid?
  end

  test "user should be present" do
    @swipe.user = nil
    assert_not @swipe.valid?
  end

  test "video should be present" do
    @swipe.video = nil
    assert_not @swipe.valid?
  end

  test "game should be present" do
    @swipe.game = nil
    assert_not @swipe.valid?
  end

  test "action should be present" do
    @swipe.action = "   "
    assert_not @swipe.valid?
  end

  test "action should be either like or dislike" do
    @swipe.action = "invalid"
    assert_not @swipe.valid?
    
    @swipe.action = "like"
    assert @swipe.valid?
    
    @swipe.action = "dislike"
    assert @swipe.valid?
  end

  test "liked should be boolean" do
    @swipe.liked = nil
    assert_not @swipe.valid?
    
    @swipe.liked = true
    assert @swipe.valid?
    
    @swipe.liked = false
    assert @swipe.valid?
  end

  test "should belong to user" do
    assert_respond_to @swipe, :user
  end

  test "should belong to video" do
    assert_respond_to @swipe, :video
  end

  test "should belong to game" do
    assert_respond_to @swipe, :game
  end

  test "should belong to playlist" do
    assert_respond_to @swipe, :playlist
  end

  test "user should be unique per video and game" do
    @swipe.save!
    
    duplicate_swipe = Swipe.new(user: @user, video: @video, game: @game, action: 'dislike', liked: false, playlist: @playlist)
    assert_not duplicate_swipe.valid?
  end

  test "should allow same user to swipe different videos in same game" do
    @swipe.save!
    
    other_video = videos(:two)
    other_swipe = Swipe.new(user: @user, video: other_video, game: @game, action: 'dislike', liked: false, playlist: @playlist)
    assert other_swipe.valid?
  end

  test "should allow same user to swipe same video in different games" do
    @swipe.save!
    
    other_game = Game.create!(user: @user, playlist: @playlist)
    other_swipe = Swipe.new(user: @user, video: @video, game: other_game, action: 'dislike', liked: false, playlist: @playlist)
    assert other_swipe.valid?
  end
end
