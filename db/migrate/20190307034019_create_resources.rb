class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :approved, default: false 
      t.text :content
      t.boolean :tentative, default: true 
      t.boolean :removed, default: false 
      t.boolean :flagged, default: false 
      t.integer :views

      t.timestamps
    end
  end
end
