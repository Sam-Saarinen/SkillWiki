class Assignment < ApplicationRecord
  belongs_to :student, :class_name => 'User'
  belongs_to :teacher, :class_name => 'User'
  belongs_to :classroom
  belongs_to :topic
  validates :student, :classroom, :teacher, :topic, :due_date, presence: true
end
