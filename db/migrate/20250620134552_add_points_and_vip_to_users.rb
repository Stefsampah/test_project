class AddPointsAndVipToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :points, :integer
    add_column :users, :vip_subscription, :boolean
    add_column :users, :vip_expires_at, :datetime
  end
end
