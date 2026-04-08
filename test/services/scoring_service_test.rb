require "test_helper"

class ScoringServiceTest < ActiveSupport::TestCase
  test "raw score uses likes and dislikes weights" do
    game = games(:one)
    game.swipes.destroy_all

    game.swipes.create!(user: users(:one), video: videos(:one), playlist: playlists(:one), action: "like", liked: true)
    game.swipes.create!(user: users(:one), video: videos(:two), playlist: playlists(:one), action: "dislike", liked: false)

    assert_equal 3, ScoringService.raw_game_score(game)
  end

  test "anti abuse applies malus for extreme like ratio" do
    game = games(:one)
    game.swipes.destroy_all

    6.times do
      game.swipes.build(user: users(:one), playlist: playlists(:one), action: "like", liked: true)
    end
    game.swipes.each_with_index { |s, i| s.video = Video.create!(title: "v#{i}", youtube_id: "yt#{i}abcdefgh", playlist: playlists(:one)) }
    game.swipes.each(&:save!)

    assert_equal 0.85, ScoringService.anti_abuse_multiplier(game)
    assert_equal 10, ScoringService.final_game_score(game) # 12 * 0.85 => 10.2 => 10
  end

  test "anti abuse applies malus for extreme dislike ratio" do
    game = games(:one)
    game.swipes.destroy_all

    6.times do
      game.swipes.build(user: users(:one), playlist: playlists(:one), action: "dislike", liked: false)
    end
    game.swipes.each_with_index { |s, i| s.video = Video.create!(title: "d#{i}", youtube_id: "dz#{i}abcdefghi", playlist: playlists(:one)) }
    game.swipes.each(&:save!)

    assert_equal 0.85, ScoringService.anti_abuse_multiplier(game)
    assert_equal 5, ScoringService.final_game_score(game) # 6 * 0.85 => 5.1 => 5
  end
end
