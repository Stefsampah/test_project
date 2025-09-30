require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should redirect to login when not authenticated for show" do
    get profile_url(@user)
    assert_redirected_to new_user_session_path
  end

  test "should show profile when authenticated" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
  end

  test "should show own profile" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
  end

  test "should show other user profile" do
    other_user = users(:two)
    sign_in @user
    get profile_url(other_user)
    assert_response :success
  end

  test "should redirect to login when not authenticated for edit" do
    get edit_profile_url(@user)
    assert_redirected_to new_user_session_path
  end

  test "should get edit when authenticated" do
    sign_in @user
    get edit_profile_url(@user)
    assert_response :success
  end

  test "should update profile when authenticated" do
    sign_in @user
    patch profile_url(@user), params: { 
      user: { 
        username: "NewUsername"
      } 
    }
    assert_redirected_to profile_url(@user)
    @user.reload
    assert_equal "NewUsername", @user.username
  end

  test "should not update profile when not authenticated" do
    original_username = @user.username
    patch profile_url(@user), params: { 
      user: { 
        username: "NewUsername"
      } 
    }
    assert_redirected_to new_user_session_path
    @user.reload
    assert_equal original_username, @user.username
  end

  test "should not update other user profile" do
    other_user = users(:two)
    original_username = other_user.username
    sign_in @user
    
    patch profile_url(other_user), params: { 
      user: { 
        username: "HackedUsername"
      } 
    }
    assert_response :forbidden
    other_user.reload
    assert_equal original_username, other_user.username
  end

  test "should show user badges" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les badges sont affichés
    assert_select "div", text: /Badge/
  end

  test "should show user scores" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les scores sont affichés
    assert_select "div", text: /Score/
  end

  test "should show user games" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les jeux sont affichés
    assert_select "div", text: /Game/
  end

  test "should show user rewards" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les récompenses sont affichées
    assert_select "div", text: /Reward/
  end

  test "should show user points" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les points sont affichés
    assert_select "text", text: /points/
  end

  test "should show user statistics" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les statistiques sont affichées
    assert_select "div", text: /Stat/
  end

  test "should show user achievements" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les réalisations sont affichées
    assert_select "div", text: /Achievement/
  end

  test "should show user playlists" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les playlists sont affichées
    assert_select "div", text: /Playlist/
  end

  test "should show user unlocked content" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que le contenu débloqué est affiché
    assert_select "div", text: /Unlocked/
  end

  test "should handle profile update with invalid data" do
    sign_in @user
    patch profile_url(@user), params: { 
      user: { 
        email: "invalid-email"
      } 
    }
    assert_response :unprocessable_entity
  end

  test "should handle profile update with valid data" do
    sign_in @user
    patch profile_url(@user), params: { 
      user: { 
        username: "ValidUsername",
        bio: "New bio"
      } 
    }
    assert_redirected_to profile_url(@user)
    @user.reload
    assert_equal "ValidUsername", @user.username
    assert_equal "New bio", @user.bio
  end

  test "should show profile edit form" do
    sign_in @user
    get edit_profile_url(@user)
    assert_response :success
    # Vérifier que le formulaire d'édition est affiché
    assert_select "form"
  end

  test "should show profile information" do
    sign_in @user
    get profile_url(@user)
    assert_response :success
    # Vérifier que les informations du profil sont affichées
    assert_select "h1", text: /🎯/
  end
end
