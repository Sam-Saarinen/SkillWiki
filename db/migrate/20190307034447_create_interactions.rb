class CreateInteractions < ActiveRecord::Migration[5.2]
  def change
    create_table :interactions do |t|
      t.references :user, foreign_key: true
      t.references :resource, foreign_key: true
      t.references :topic, foreign_key: true
      t.integer :helpful_q
      t.integer :confidence_q
      t.float :time_taken
      t.boolean :reported, default: false 

      t.timestamps
    end
  end
end
