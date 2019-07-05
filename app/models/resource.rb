class Resource < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  # attribute :helpful_avg, :float, default: 0.0 
  # FIXME: SQL default value is still nill so this is a temporary fix? Migration changing default run into SQL exception of foreign key constraint.
  # Could make a helper that sets nil to 0
  # attribute :feedback_count, :integer, default: 0
  
  # Updates running helpfulness average with value from new feedback
  def update_avg(val)
    self.feedback_count += 1
    dif = (val - self.helpful_avg) / self.feedback_count
    self.helpful_avg += dif
    self.save
  end
  
  # Updates running helpfulness average by replacing value of old feedback 
  # with value from new feedback
  def update_avg_with_old_val(val, old_val)
    dif = (val / self.feedback_count) - (old_val / self.feedback_count)
    self.helpful_avg += dif
    self.save
  end
end
