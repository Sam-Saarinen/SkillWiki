class AddJoinCodeToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :join_code, :string
    add_index :classrooms, :join_code, unique: true
  end
end
