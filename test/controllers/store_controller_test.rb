require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should get index" do
    get store_url
    assert_response :success
  end

  test "should get index when authenticated" do
    sign_in @user
    get store_url
    assert_response :success
  end

  test "should show points packages" do
    get store_url
    assert_response :success
    # Vérifier que les packages de points sont affichés
    assert_select "h2", text: /Points/
  end

  test "should show premium playlists" do
    get store_url
    assert_response :success
    # Vérifier que les playlists premium sont affichées
    assert_select "h2", text: /Premium/
  end

  test "should show exclusive content" do
    get store_url
    assert_response :success
    # Vérifier que le contenu exclusif est affiché
    assert_select "h2", text: /Exclusif/
  end

  test "should handle purchase points when authenticated" do
    sign_in @user
    post store_url, params: { 
      purchase: { 
        type: 'points',
        amount: 100,
        price: 9.99
      } 
    }
    assert_response :success
  end

  test "should not handle purchase when not authenticated" do
    post store_url, params: { 
      purchase: { 
        type: 'points',
        amount: 100,
        price: 9.99
      } 
    }
    assert_redirected_to new_user_session_path
  end

  test "should handle unlock playlist when authenticated" do
    sign_in @user
    playlist = playlists(:two) # Premium playlist
    post store_url, params: { 
      purchase: { 
        type: 'playlist',
        playlist_id: playlist.id,
        price: 500
      } 
    }
    assert_response :success
  end

  test "should not unlock playlist when not authenticated" do
    playlist = playlists(:two) # Premium playlist
    post store_url, params: { 
      purchase: { 
        type: 'playlist',
        playlist_id: playlist.id,
        price: 500
      } 
    }
    assert_redirected_to new_user_session_path
  end

  test "should handle unlock exclusive content when authenticated" do
    sign_in @user
    post store_url, params: { 
      purchase: { 
        type: 'exclusive',
        content_id: 1,
        price: 1000
      } 
    }
    assert_response :success
  end

  test "should not unlock exclusive content when not authenticated" do
    post store_url, params: { 
      purchase: { 
        type: 'exclusive',
        content_id: 1,
        price: 1000
      } 
    }
    assert_redirected_to new_user_session_path
  end

  test "should show user points when authenticated" do
    sign_in @user
    get store_url
    assert_response :success
    # Vérifier que les points de l'utilisateur sont affichés
    assert_select "text", text: /points/
  end

  test "should show available purchases" do
    get store_url
    assert_response :success
    # Vérifier que les options d'achat sont affichées
    assert_select "button", text: /Acheter/
  end

  test "should handle insufficient points" do
    sign_in @user
    # Simuler un utilisateur avec peu de points
    @user.update!(game_points: 100)
    
    playlist = playlists(:two) # Premium playlist (500 points)
    post store_url, params: { 
      purchase: { 
        type: 'playlist',
        playlist_id: playlist.id,
        price: 500
      } 
    }
    assert_response :unprocessable_entity
  end

  test "should handle valid purchase" do
    sign_in @user
    # Simuler un utilisateur avec suffisamment de points
    @user.update!(game_points: 1000)
    
    playlist = playlists(:two) # Premium playlist (500 points)
    post store_url, params: { 
      purchase: { 
        type: 'playlist',
        playlist_id: playlist.id,
        price: 500
      } 
    }
    assert_response :success
  end

  test "should show different point packages" do
    get store_url
    assert_response :success
    # Vérifier que différents packages sont affichés
    assert_select "div", text: /100 points/
    assert_select "div", text: /500 points/
    assert_select "div", text: /1000 points/
  end

  test "should show premium playlist prices" do
    get store_url
    assert_response :success
    # Vérifier que les prix des playlists premium sont affichés
    assert_select "div", text: /500 points/
  end

  test "should show exclusive content prices" do
    get store_url
    assert_response :success
    # Vérifier que les prix du contenu exclusif sont affichés
    assert_select "div", text: /1000 points/
  end
end
