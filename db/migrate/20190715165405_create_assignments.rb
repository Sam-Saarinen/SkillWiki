class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.references :student
      t.references :classroom, foreign_key: true
      t.references :teacher
      t.references :topic, foreign_key: true
      t.datetime :due_date
      t.text :resources_completed
      t.datetime :start_date
      t.float :quiz_score

      t.timestamps
    end
  end
end
