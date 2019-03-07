class Resource < ApplicationRecord
  belongs_to :topic
  belongs_to :user
end
