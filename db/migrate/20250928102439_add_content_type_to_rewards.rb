class AddContentTypeToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :content_type, :string
  end
end
