class AddRewardDetailsToGadges < ActiveRecord::Migration[7.1]
  def change
    add_column :gadges, :reward_description, :string
    add_column :gadges, :image, :string
  end
end
