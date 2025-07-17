class AddMultipleConditionsToBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :badges, :condition_1_type, :string
    add_column :badges, :condition_1_value, :integer
    add_column :badges, :condition_2_type, :string
    add_column :badges, :condition_2_value, :integer
    add_column :badges, :condition_3_type, :string
    add_column :badges, :condition_3_value, :integer
  end
end
