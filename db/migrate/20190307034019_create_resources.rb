class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :approved
      t.text :content
      t.boolean :tentative
      t.boolean :removed
      t.boolean :flagged
      t.integer :views

      t.timestamps
    end
  end
end
