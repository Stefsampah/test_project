class RemoveRewardsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :rewards if table_exists?(:rewards)
  end
end
