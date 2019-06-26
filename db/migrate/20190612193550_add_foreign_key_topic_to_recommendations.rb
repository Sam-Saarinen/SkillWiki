class AddForeignKeyTopicToRecommendations < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :recommendations, :topics
    add_foreign_key :recommendations, :topics, on_delete: :cascade
  end
end
