class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :name
      t.boolean :approved, default: false 
      t.text :description
      
      t.references :user

      t.timestamps
    end
  end
end
