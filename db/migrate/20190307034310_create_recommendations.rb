class CreateRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :recommendations do |t|
      t.references :user, foreign_key: true
      # SHOULD NOT BE ?; PLACEHOLDER BECAUSE IDK HOW TO MAKE
      # DATATYPE LIST<RESOURCE.ID>
      t.? :content
      t.references :topic, foreign_key: true

      t.timestamps
    end
  end
end
