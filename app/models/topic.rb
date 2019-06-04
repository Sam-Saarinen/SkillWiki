class Topic < ApplicationRecord
  # FIXME: Fix relationship so that topic is not deleted if creator is deleted.
  belongs_to :user
  has_many :resource
end
