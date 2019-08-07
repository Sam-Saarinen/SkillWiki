class Classroom < ApplicationRecord
  belongs_to :user
  has_many :assignments
  validates :join_code, uniqueness: true
  has_and_belongs_to_many :enrolled, :class_name => 'User'
  
  # Returns the number of students in this class
  def num_students
    self.enrolled.size - 1 # Subtract teacher from total
  end 
  
end
