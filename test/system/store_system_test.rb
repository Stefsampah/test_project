require "application_system_test_case"

class StoreSystemTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
  end

  test "visiting the store" do
    visit store_url
    assert_selector "h1", text: "Store"
  end

  test "viewing points packages" do
    visit store_url
    
    # Should show points packages
    assert_selector "h2", text: "Points Packages"
    assert_text "100 points"
    assert_text "500 points"
    assert_text "1000 points"
  end

  test "viewing premium playlists" do
    visit store_url
    
    # Should show premium playlists
    assert_selector "h2", text: "Premium Playlists"
    assert_text "Unlock premium content"
  end

  test "viewing exclusive content" do
    visit store_url
    
    # Should show exclusive content
    assert_selector "h2", text: "Exclusive Content"
    assert_text "Special rewards"
  end

  test "purchasing points when authenticated" do
    sign_in @user
    visit store_url
    
    # Click on points package
    click_on "100 points"
    
    # Should show purchase confirmation
    assert_text "Purchase Confirmation"
    assert_text "100 points"
    assert_text "Price: $9.99"
    
    # Confirm purchase
    click_button "Confirm Purchase"
    
    # Should show success message
    assert_text "Purchase successful"
    assert_text "100 points added to your account"
  end

  test "purchasing points when not authenticated" do
    visit store_url
    
    # Click on points package
    click_on "100 points"
    
    # Should redirect to login
    assert_current_path new_user_session_path
  end

  test "unlocking premium playlist when authenticated" do
    sign_in @user
    @user.update!(game_points: 1000) # Enough points
    
    visit store_url
    
    # Click on premium playlist
    click_on "Unlock Premium Playlist"
    
    # Should show unlock confirmation
    assert_text "Unlock Confirmation"
    assert_text "500 points required"
    assert_text "You have 1000 points"
    
    # Confirm unlock
    click_button "Confirm Unlock"
    
    # Should show success message
    assert_text "Playlist unlocked successfully"
    assert_text "Premium content now available"
    
    # Should deduct points
    @user.reload
    assert_equal 500, @user.game_points
  end

  test "unlocking premium playlist with insufficient points" do
    sign_in @user
    @user.update!(game_points: 100) # Not enough points
    
    visit store_url
    
    # Click on premium playlist
    click_on "Unlock Premium Playlist"
    
    # Should show error
    assert_text "Insufficient points"
    assert_text "You need 400 more points"
    
    # Should not deduct points
    @user.reload
    assert_equal 100, @user.game_points
  end

  test "unlocking exclusive content when authenticated" do
    sign_in @user
    @user.update!(game_points: 1000) # Enough points
    
    visit store_url
    
    # Click on exclusive content
    click_on "Unlock Exclusive Content"
    
    # Should show unlock confirmation
    assert_text "Unlock Confirmation"
    assert_text "1000 points required"
    assert_text "You have 1000 points"
    
    # Confirm unlock
    click_button "Confirm Unlock"
    
    # Should show success message
    assert_text "Exclusive content unlocked successfully"
    assert_text "Special rewards now available"
    
    # Should deduct points
    @user.reload
    assert_equal 0, @user.game_points
  end

  test "viewing user points when authenticated" do
    sign_in @user
    @user.update!(game_points: 500)
    
    visit store_url
    
    # Should show user points
    assert_text "Your Points: 500"
  end

  test "viewing purchase history when authenticated" do
    sign_in @user
    visit store_url
    
    # Click on purchase history
    click_on "Purchase History"
    
    # Should show purchase history
    assert_selector "h2", text: "Purchase History"
  end

  test "viewing unlocked content when authenticated" do
    sign_in @user
    visit store_url
    
    # Click on unlocked content
    click_on "Unlocked Content"
    
    # Should show unlocked content
    assert_selector "h2", text: "Unlocked Content"
  end

  test "viewing store categories" do
    visit store_url
    
    # Should show store categories
    assert_text "Points"
    assert_text "Premium Playlists"
    assert_text "Exclusive Content"
    assert_text "Special Offers"
  end

  test "viewing special offers" do
    visit store_url
    
    # Should show special offers
    assert_selector "h2", text: "Special Offers"
    assert_text "Limited time offers"
  end

  test "viewing store recommendations" do
    sign_in @user
    visit store_url
    
    # Should show recommendations
    assert_selector "h2", text: "Recommendations"
    assert_text "Based on your activity"
  end

  test "viewing store statistics" do
    visit store_url
    
    # Should show statistics
    assert_text "Store Statistics"
    assert_text "Total purchases"
    assert_text "Popular items"
  end

  test "viewing store leaderboard" do
    visit store_url
    
    # Should show leaderboard
    assert_text "Store Leaderboard"
    assert_text "Top spenders"
  end

  test "viewing store reviews" do
    visit store_url
    
    # Should show reviews
    assert_text "Store Reviews"
    assert_text "Customer feedback"
  end

  test "viewing store support" do
    visit store_url
    
    # Should show support
    assert_text "Store Support"
    assert_text "Help and support"
  end

  test "viewing store terms" do
    visit store_url
    
    # Should show terms
    assert_text "Terms and Conditions"
    assert_text "Purchase terms"
  end

  test "viewing store privacy" do
    visit store_url
    
    # Should show privacy policy
    assert_text "Privacy Policy"
    assert_text "Data protection"
  end

  test "viewing store refunds" do
    visit store_url
    
    # Should show refund policy
    assert_text "Refund Policy"
    assert_text "Refund terms"
  end

  test "viewing store contact" do
    visit store_url
    
    # Should show contact information
    assert_text "Contact Us"
    assert_text "Customer service"
  end

  test "viewing store FAQ" do
    visit store_url
    
    # Should show FAQ
    assert_text "FAQ"
    assert_text "Frequently asked questions"
  end

  test "viewing store newsletter" do
    visit store_url
    
    # Should show newsletter signup
    assert_text "Newsletter"
    assert_text "Stay updated"
  end

  test "viewing store social media" do
    visit store_url
    
    # Should show social media links
    assert_text "Follow Us"
    assert_text "Social media"
  end

  test "viewing store mobile app" do
    visit store_url
    
    # Should show mobile app information
    assert_text "Mobile App"
    assert_text "Download our app"
  end

  test "viewing store accessibility" do
    visit store_url
    
    # Should show accessibility information
    assert_text "Accessibility"
    assert_text "Accessibility features"
  end

  test "viewing store language options" do
    visit store_url
    
    # Should show language options
    assert_text "Language"
    assert_text "Select language"
  end

  test "viewing store currency options" do
    visit store_url
    
    # Should show currency options
    assert_text "Currency"
    assert_text "Select currency"
  end

  test "viewing store payment methods" do
    visit store_url
    
    # Should show payment methods
    assert_text "Payment Methods"
    assert_text "Accepted payment methods"
  end

  test "viewing store security" do
    visit store_url
    
    # Should show security information
    assert_text "Security"
    assert_text "Secure payments"
  end

  test "viewing store guarantees" do
    visit store_url
    
    # Should show guarantees
    assert_text "Guarantees"
    assert_text "Money-back guarantee"
  end
end
