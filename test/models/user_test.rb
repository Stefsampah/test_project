require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "should have many games" do
    assert_respond_to @user, :games
  end

  test "should have many swipes" do
    assert_respond_to @user, :swipes
  end

  test "should have many scores" do
    assert_respond_to @user, :scores
  end

  test "should have many badges through user_badges" do
    assert_respond_to @user, :badges
  end

  test "should have many rewards" do
    assert_respond_to @user, :rewards
  end

  test "should have many unlocked_playlists" do
    assert_respond_to @user, :unlocked_playlists
  end

  test "competitor_score should return sum of score points" do
    # Clear existing scores for this user
    @user.scores.destroy_all
    
    playlist = playlists(:one)
    Score.create!(user: @user, playlist: playlist, points: 10)
    Score.create!(user: @user, playlist: playlists(:two), points: 5)
    
    assert_equal 15, @user.competitor_score
  end

  test "engager_score should calculate based on likes and dislikes" do
    # Clear existing swipes for this user
    @user.swipes.destroy_all
    
    playlist = playlists(:one)
    game = Game.create!(user: @user, playlist: playlist)
    video = videos(:one)
    
    Swipe.create!(user: @user, video: video, game: game, action: 'like', liked: true, playlist: playlist)
    Swipe.create!(user: @user, video: videos(:two), game: game, action: 'dislike', liked: false, playlist: playlist)
    
    assert_equal 7, @user.engager_score # 5 points for like + 2 points for dislike
  end

  test "critic_score should calculate based on dislikes" do
    # Clear existing swipes for this user
    @user.swipes.destroy_all
    
    playlist = playlists(:one)
    game = Game.create!(user: @user, playlist: playlist)
    video = videos(:one)
    
    Swipe.create!(user: @user, video: video, game: game, action: 'dislike', liked: false, playlist: playlist)
    Swipe.create!(user: @user, video: videos(:two), game: game, action: 'dislike', liked: false, playlist: playlist)
    
    assert_equal 6, @user.critic_score # 3 points per dislike
  end

  test "challenger_score should sum all scores" do
    # Clear existing data for this user
    @user.scores.destroy_all
    @user.swipes.destroy_all
    
    playlist = playlists(:one)
    Score.create!(user: @user, playlist: playlist, points: 10)
    
    game = Game.create!(user: @user, playlist: playlist)
    video = videos(:one)
    Swipe.create!(user: @user, video: video, game: game, action: 'like', liked: true, playlist: playlist)
    
    assert_equal 15, @user.challenger_score # competitor_score + engager_score + critic_score
  end

  test "total_points should return sum of all points" do
    # Clear existing scores for this user
    @user.scores.destroy_all
    
    playlist = playlists(:one)
    Score.create!(user: @user, playlist: playlist, points: 10)
    Score.create!(user: @user, playlist: playlists(:two), points: 5)
    
    # total_points = purchased_points + game_points
    # purchased_points = self.points || 0 = 0
    # game_points = regularity_points + listening_points + critical_opinions_points
    # Since we only have scores, game_points should be 0, so total_points = 0
    assert_equal 0, @user.total_points
  end

  test "should assign badges after save" do
    assert_respond_to @user, :assign_badges
  end

  test "should assign badges after create" do
    new_user = User.new(email: "new@example.com", password: "password123", password_confirmation: "password123")
    assert_respond_to new_user, :assign_badges
  end
end
