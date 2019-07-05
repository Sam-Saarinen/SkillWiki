class Topic < ApplicationRecord
  # FIXME: Fix relationship so that topic is not deleted if creator is deleted.
  belongs_to :user
  has_many :resource, :dependent => :delete_all 
  has_many :recommendation, :dependent => :delete_all 
end
