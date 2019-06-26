class AddReviewedToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :reviewed, :boolean, :default => false
  end
end
