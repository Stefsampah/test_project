class AddPremiumAndGenreToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :premium, :boolean
    add_column :playlists, :genre, :string
    add_column :playlists, :points_required, :integer
  end
end
