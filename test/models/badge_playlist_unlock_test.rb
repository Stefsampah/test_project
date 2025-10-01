require "test_helper"

class BadgePlaylistUnlockTest < ActiveSupport::TestCase
  def setup
    @badge = badges(:one) # Utiliser la fixture existante
    @playlist = playlists(:one)
    @unlock = BadgePlaylistUnlock.new(badge: @badge, playlist: @playlist)
  end

  test "should be valid" do
    assert @unlock.valid?
  end

  test "badge_id should be present" do
    @unlock.badge = nil
    assert_not @unlock.valid?
  end

  test "playlist_id should be present" do
    @unlock.playlist = nil
    assert_not @unlock.valid?
  end

  test "should belong to badge" do
    assert_respond_to @unlock, :badge
  end

  test "should belong to playlist" do
    assert_respond_to @unlock, :playlist
  end

  test "badge_id should be unique per playlist" do
    @unlock.save!
    
    duplicate_unlock = BadgePlaylistUnlock.new(badge: @badge, playlist: @playlist)
    assert_not duplicate_unlock.valid?
  end

  test "should allow same badge to unlock different playlists" do
    @unlock.save!
    
    other_playlist = playlists(:two)
    other_unlock = BadgePlaylistUnlock.new(badge: @badge, playlist: other_playlist)
    
    assert other_unlock.valid?
    assert other_unlock.save
  end

  test "should allow same playlist to be unlocked by different badges" do
    @unlock.save!
    
    other_badge = Badge.create!(
      name: "Other Badge",
      badge_type: "engager",
      level: "silver",
      points_required: 200,
      description: "Other badge description"
    )
    other_unlock = BadgePlaylistUnlock.new(badge: other_badge, playlist: @playlist)
    
    assert other_unlock.valid?
    assert other_unlock.save
  end

  test "should create unlock successfully" do
    assert_difference 'BadgePlaylistUnlock.count', 1 do
      @unlock.save!
    end
  end
end
