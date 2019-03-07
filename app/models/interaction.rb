class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :resource
end
