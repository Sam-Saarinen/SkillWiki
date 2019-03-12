class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :name
      t.boolean :approved
      t.text :description
      t.references :users 

      t.timestamps
    end
  end
end
