require "test_helper"

class ScoreTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @score = Score.new(user: @user, playlist: @playlist, points: 10)
  end

  test "should be valid" do
    assert @score.valid?
  end

  test "points should be present" do
    @score.points = nil
    assert_not @score.valid?
  end

  test "points should be an integer" do
    @score.points = 10.5
    assert_not @score.valid?
  end

  test "points should be greater than or equal to 0" do
    @score.points = -1
    assert_not @score.valid?
    
    @score.points = 0
    assert @score.valid?
    
    @score.points = 10
    assert @score.valid?
  end

  test "user_id should be present" do
    @score.user = nil
    assert_not @score.valid?
  end

  test "playlist_id should be present" do
    @score.playlist = nil
    assert_not @score.valid?
  end

  test "should belong to user" do
    assert_respond_to @score, :user
  end

  test "should belong to playlist" do
    assert_respond_to @score, :playlist
  end

  test "calculate_top_engager_scores should return sorted scores" do
    scores = Score.calculate_top_engager_scores
    assert scores.is_a?(Array)
    
    # Should be sorted by points descending
    if scores.length > 1
      assert scores[0][:points] >= scores[1][:points]
    end
  end

  test "calculate_best_ratio_scores should return sorted scores" do
    scores = Score.calculate_best_ratio_scores
    assert scores.is_a?(Array)
    
    # Should be sorted by points descending
    if scores.length > 1
      assert scores[0][:points] >= scores[1][:points]
    end
  end

  test "calculate_wise_critic_scores should return sorted scores" do
    scores = Score.calculate_wise_critic_scores
    assert scores.is_a?(Array)
    
    # Should be sorted by points descending
    if scores.length > 1
      assert scores[0][:points] >= scores[1][:points]
    end
  end

  test "calculate_total_scores should return sorted scores" do
    scores = Score.calculate_total_scores
    assert scores.is_a?(Array)
    
    # Should be sorted by points descending
    if scores.length > 1
      assert scores[0][:points] >= scores[1][:points]
    end
  end

  test "badges should return array of badge names" do
    badges = @score.badges
    assert badges.is_a?(Array)
  end

  test "badges should include Best Ratio du jour for balanced ratios" do
    # Create swipes with balanced ratio (40-60%)
    game = Game.create!(user: @user, playlist: @playlist)
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Create 2 likes and 3 dislikes (40% likes, 60% dislikes)
    Swipe.create!(user: @user, video: video1, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video1, game: game, action: 'dislike', liked: false, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: game, action: 'dislike', liked: false, playlist: @playlist)
    Swipe.create!(user: @user, video: video1, game: game, action: 'dislike', liked: false, playlist: @playlist)
    
    badges = @score.badges
    assert_includes badges, "Best Ratio du jour"
  end

  test "badges should include Wise Critic du jour for small gaps" do
    # Create swipes with small gap between likes and dislikes
    game = Game.create!(user: @user, playlist: @playlist)
    video1 = videos(:one)
    video2 = videos(:two)
    
    # Create 3 likes and 2 dislikes (60% likes, 40% dislikes, gap = 20%)
    Swipe.create!(user: @user, video: video1, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video1, game: game, action: 'like', liked: true, playlist: @playlist)
    Swipe.create!(user: @user, video: video2, game: game, action: 'dislike', liked: false, playlist: @playlist)
    Swipe.create!(user: @user, video: video1, game: game, action: 'dislike', liked: false, playlist: @playlist)
    
    badges = @score.badges
    assert_includes badges, "Wise Critic du jour"
  end
end
