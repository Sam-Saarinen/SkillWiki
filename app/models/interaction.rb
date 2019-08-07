class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :topic 
end
