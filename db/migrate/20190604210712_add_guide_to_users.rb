class AddGuideToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guide, :integer
  end
end
