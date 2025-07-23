class CreateBadgePlaylistUnlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :badge_playlist_unlocks do |t|
      t.references :badge, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
