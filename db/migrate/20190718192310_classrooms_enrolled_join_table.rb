class ClassroomsEnrolledJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :classrooms_users, id: false do |t|
      t.integer :classroom_id
      t.integer :user_id
    end
 
    add_index :classrooms_users, :classroom_id
    add_index :classrooms_users, :user_id
  end
end
