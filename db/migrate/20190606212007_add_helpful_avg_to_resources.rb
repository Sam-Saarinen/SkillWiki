class AddHelpfulAvgToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :helpful_avg, :float
  end
end
