class AddBadgesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :badges, :text
  end
end
