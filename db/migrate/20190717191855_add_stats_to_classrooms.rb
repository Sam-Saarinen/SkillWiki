class AddStatsToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :stats, :text
  end
end
