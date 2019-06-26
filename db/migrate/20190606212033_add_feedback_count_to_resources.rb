class AddFeedbackCountToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :feedback_count, :integer
  end
end
