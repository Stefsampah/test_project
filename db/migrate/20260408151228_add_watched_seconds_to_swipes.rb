class AddWatchedSecondsToSwipes < ActiveRecord::Migration[7.1]
  def change
    add_column :swipes, :watched_seconds, :integer, default: 0, null: false
    add_index :swipes, :watched_seconds
  end
end
