class AddHiddenToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :hidden, :boolean
  end
end
