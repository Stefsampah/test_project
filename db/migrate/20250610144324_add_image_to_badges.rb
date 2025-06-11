class AddImageToBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :badges, :image, :string
  end
end
