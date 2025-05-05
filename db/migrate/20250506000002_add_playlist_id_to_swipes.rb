class AddPlaylistIdToSwipes < ActiveRecord::Migration[7.1]
  def change
    add_reference :swipes, :playlist, foreign_key: true
  end
end 