class CreateUserPlaylistUnlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_playlist_unlocks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
