require "test_helper"

class SwipesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @game = Game.create!(user: @user, playlist: @playlist)
    @video = videos(:one)
  end

  test "should create swipe when authenticated" do
    sign_in @user
    assert_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: @game.id,
          action: 'like'
        } 
      }
    end
    assert_response :success
  end

  test "should not create swipe when not authenticated" do
    assert_no_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: @game.id,
          action: 'like'
        } 
      }
    end
    assert_response :redirect
  end

  test "should create like swipe" do
    sign_in @user
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    swipe = Swipe.last
    assert_equal 'like', swipe.action
    assert_equal true, swipe.liked
  end

  test "should create dislike swipe" do
    sign_in @user
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'dislike'
      } 
    }
    assert_response :success
    
    swipe = Swipe.last
    assert_equal 'dislike', swipe.action
    assert_equal false, swipe.liked
  end

  test "should not create swipe with invalid action" do
    sign_in @user
    assert_no_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: @game.id,
          action: 'invalid'
        } 
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create swipe with invalid video" do
    sign_in @user
    assert_no_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: 99999,
          game_id: @game.id,
          action: 'like'
        } 
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create swipe with invalid game" do
    sign_in @user
    assert_no_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: 99999,
          action: 'like'
        } 
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create duplicate swipe" do
    sign_in @user
    # Create first swipe
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    # Try to create duplicate
    assert_no_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: @game.id,
          action: 'dislike'
        } 
      }
    end
    assert_response :unprocessable_entity
  end

  test "should create swipe for different videos in same game" do
    sign_in @user
    video2 = videos(:two)
    
    # Create first swipe
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    # Create second swipe for different video
    assert_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: video2.id,
          game_id: @game.id,
          action: 'dislike'
        } 
      }
    end
    assert_response :success
  end

  test "should create swipe for same video in different games" do
    sign_in @user
    game2 = Game.create!(user: @user, playlist: @playlist)
    
    # Create first swipe
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    # Create second swipe for different game
    assert_difference('Swipe.count') do
      post swipes_url, params: { 
        swipe: { 
          video_id: @video.id,
          game_id: game2.id,
          action: 'dislike'
        } 
      }
    end
    assert_response :success
  end

  test "should return next video after swipe" do
    sign_in @user
    video2 = videos(:two)
    
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    response_data = JSON.parse(response.body)
    assert response_data['next_video']
  end

  test "should return game completion status" do
    sign_in @user
    video2 = videos(:two)
    
    # Swipe first video
    post swipes_url, params: { 
      swipe: { 
        video_id: @video.id,
        game_id: @game.id,
        action: 'like'
      } 
    }
    assert_response :success
    
    # Swipe second video (completing the game)
    post swipes_url, params: { 
      swipe: { 
        video_id: video2.id,
        game_id: @game.id,
        action: 'dislike'
      } 
    }
    assert_response :success
    
    response_data = JSON.parse(response.body)
    assert response_data['game_completed']
  end
end
