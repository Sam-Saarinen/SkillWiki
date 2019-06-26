class AddSampledRewardToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :sampled_reward, :float, :default => 0.0
  end
end
