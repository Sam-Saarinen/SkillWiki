class AddContentToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :content, :text
  end
end
