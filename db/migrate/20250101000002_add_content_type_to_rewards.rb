class AddContentTypeToRewards < ActiveRecord::Migration[7.0]
  def change
    add_column :rewards, :content_type, :string
    add_column :rewards, :icon, :string
    add_column :rewards, :claimed, :boolean, default: false
    add_column :rewards, :claimed_at, :datetime
    
    add_index :rewards, :content_type
    add_index :rewards, :claimed
  end
end 