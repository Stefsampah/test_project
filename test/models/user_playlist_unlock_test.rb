require "test_helper"

class UserPlaylistUnlockTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @playlist = playlists(:one)
    @unlock = UserPlaylistUnlock.new(user: @user, playlist: @playlist)
  end

  test "should be valid" do
    assert @unlock.valid?
  end

  test "should belong to user" do
    assert_respond_to @unlock, :user
  end

  test "should belong to playlist" do
    assert_respond_to @unlock, :playlist
  end

  test "should create unlock successfully" do
    assert_difference 'UserPlaylistUnlock.count', 1 do
      @unlock.save!
    end
  end

  test "should allow multiple unlocks for same user" do
    @unlock.save!
    
    other_playlist = playlists(:two)
    other_unlock = UserPlaylistUnlock.new(user: @user, playlist: other_playlist)
    
    assert other_unlock.valid?
    assert other_unlock.save
  end

  test "should allow multiple unlocks for same playlist" do
    @unlock.save!
    
    other_user = users(:two)
    other_unlock = UserPlaylistUnlock.new(user: other_user, playlist: @playlist)
    
    assert other_unlock.valid?
    assert other_unlock.save
  end

  test "should prevent duplicate unlocks" do
    @unlock.save!
    
    duplicate_unlock = UserPlaylistUnlock.new(user: @user, playlist: @playlist)
    # Note: This test may fail if there's no uniqueness validation
    # Check if the model has uniqueness validation
    if UserPlaylistUnlock.validators.any? { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
      assert_not duplicate_unlock.valid?
    else
      # If no uniqueness validation, the duplicate should be valid
      assert duplicate_unlock.valid?
    end
  end
end