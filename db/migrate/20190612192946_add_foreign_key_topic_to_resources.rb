class AddForeignKeyTopicToResources < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :resources, :topics
    add_foreign_key :resources, :topics, on_delete: :cascade
  end
end
