class Topic < ApplicationRecord
  # TODO: Might delete topic if user is deleted
  belongs_to :creator, foreign_key: :user, class_name:'User'
end
