require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "user can sign up" do
    visit new_user_registration_path
    
    # Vérifier que la page d'inscription s'affiche
    assert_selector "h2", text: "Sign up"
    
    # Remplir le formulaire d'inscription
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    # Soumettre le formulaire
    click_button "Sign up"
    
    # Vérifier qu'on est connecté et redirigé
    assert_current_path root_path
    assert_selector ".flash-notice", text: "Welcome! You have signed up successfully."
  end

  test "user can sign in" do
    visit new_user_session_path
    
    # Vérifier que la page de connexion s'affiche
    assert_selector "h2", text: "Connexion"
    
    # Remplir le formulaire de connexion
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    
    # Soumettre le formulaire
    click_button "Se connecter"
    
    # Vérifier qu'on est connecté et redirigé
    assert_current_path root_path
    assert_selector ".flash-notice", text: /connecté avec succès/
  end

  test "user can sign out" do
    # Se connecter d'abord
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"
    
    # Vérifier qu'on est connecté
    assert_current_path root_path
    
    # Se déconnecter
    click_button "Déconnexion"
    
    # Vérifier qu'on est déconnecté
    assert_current_path new_user_session_path
    assert_selector ".flash-notice", text: /déconnecté avec succès/
  end

  test "user cannot access protected pages when not signed in" do
    # Essayer d'accéder à une page protégée
    visit playlists_path
    
    # Vérifier qu'on est redirigé vers la page de connexion
    assert_current_path new_user_session_path
    assert_selector ".flash-alert", text: /sign in or sign up/
  end

  test "user can access protected pages when signed in" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"
    
    # Accéder à une page protégée
    visit playlists_path
    
    # Vérifier qu'on peut accéder à la page
    assert_current_path playlists_path
    assert_selector "h1", text: "Playlists"
  end

  test "user profile access" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"
    
    # Accéder au profil
    visit profile_path
    
    # Vérifier que la page de profil s'affiche
    assert_selector "h1", text: /🎯/
  end

  test "user can edit profile" do
    # Se connecter
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password"
    click_button "Se connecter"
    
    # Aller à la page d'édition du profil
    visit edit_profile_path
    
    # Vérifier que la page d'édition s'affiche
    assert_selector "h2", text: "Modifier mon profil"
    
    # Modifier le profil
    click_button "Mettre à jour"
    
    # Vérifier que les modifications sont sauvegardées
    assert_selector ".flash-notice", text: /mis à jour avec succès/
  end

  test "invalid login credentials" do
    visit new_user_session_path
    
    # Essayer de se connecter avec de mauvaises informations
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "wrongpassword"
    click_button "Se connecter"
    
    # Vérifier qu'on reste sur la page de connexion avec une erreur
    assert_current_path new_user_session_path
    assert_selector ".flash-alert", text: /Invalid.*password/
  end

  test "password confirmation mismatch on signup" do
    visit new_user_registration_path
    
    # Remplir le formulaire avec des mots de passe différents
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "differentpassword"
    
    # Soumettre le formulaire
    click_button "Sign up"
    
    # Vérifier qu'on reste sur la page d'inscription avec une erreur
    assert_current_path new_user_registration_path
    assert_selector ".flash-alert", text: /Password confirmation/
  end

  test "duplicate email on signup" do
    visit new_user_registration_path
    
    # Essayer de s'inscrire avec un email déjà utilisé
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    # Soumettre le formulaire
    click_button "Sign up"
    
    # Vérifier qu'on reste sur la page d'inscription avec une erreur
    assert_current_path new_user_registration_path
    assert_selector ".flash-alert", text: /Email.*taken/
  end
end
