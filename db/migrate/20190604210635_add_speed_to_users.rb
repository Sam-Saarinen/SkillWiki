class AddSpeedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :speed, :integer
  end
end
