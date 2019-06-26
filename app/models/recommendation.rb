require 'pycall/import'
include PyCall::Import
# pyimport :numpy, as: :np # FIXME: PyCall::PyError: Module not found
# pyimport :GPy

class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  
  def self.generate_first_recs(user, topic)
    # Sort resources by average helpfulness from greatest to least.
    resources = topic.resource.all
    resources = resources.sort_by { |res| res.helpful_avg }
    resources.reverse!
    
    # Filter out resources that have not been viewed yet.
    resources = resources.select do |rec|
      @interact = Interaction.find_by(user_id: user.id, resource_id: rec.id)
      if @interact.nil? 
        # Interaction doesn't exist at all
        true
      elsif @interact.helpful_q.nil? && @interact.confidence_q.nil? 
        # Interaction hasn't received feedback yet.
        true
      else
        false
      end 
    end 
    
    # Generate content string for new recommendation.
    content = ""
    resources.each_with_index do |res, index|
      if index == resources.length - 1
        content += res.id.to_s 
      else 
        content += res.id.to_s 
        content += ","
      end
    end

    if content.empty?
      []
    else
      @rec = Recommendation.new(user_id: user.id, topic_id: topic.id, content: content)
      
      # Either save new recommendation or update existing recommendation.
      if (rec = Recommendation.find_by(user_id: @rec.user_id, topic_id: @rec.topic_id)).nil?
        @rec.save
      else
        rec.update(content: @rec.content)
      end 
      
      resources
    end 
  end 
  
  # Thompson sampling with Gaussian priors
  def self.generate_with_ts_Gaussian(user, topic)
    pyimport :random, as: :rand # TODO: Why does import have to be inside?
    resources = topic.resource.all
    resources.each do |res|
      interactions = Interaction.where(resource_id: res.id)
      interactions = interactions.select {|i| !(i.helpful_q.nil?) }
      # TODO: Filter out interactions with nil values here.
      reward_sum = interactions.sum(&:helpful_q) 
      mean = (reward_sum + 2.5) / (interactions.length + 1) 
      # Add 2.5 for first prior so that we don't have a mean of 0 for the 1st round.
      std_dev = 1.0 / (interactions.length + 1) 
      res.sampled_reward = rand.gauss(mean, std_dev)
    end 
    resources = resources.sort_by { |res| res.sampled_reward }
    resources.reverse!
    
    resources = Recommendation.filter_out_viewed(user, resources)
    content = Recommendation.generate_content(resources)
    
    if content.empty?
      []
    else
      @rec = Recommendation.new(user_id: user.id, topic_id: topic.id, content: content)
      Recommendation.save_or_update(@rec)
      resources
    end 
  end 
  
  # Thompson sampling with Gaussian Process priors
  def self.generate_with_ts_GP(user, topic)
    resources = topic.resource.all
    # Every resource/action is modeled by a Gaussian process
    mean_rewards = []
    resources.each do |res|
      interactions = Interaction.where(resource_id: res.id)
      speed = []
      guide = []
      helpfulness = []
      interactions.each do |interact|
        helpfulness << interact.helpful_q
        u = User.find(interact.user_id)
        speed << u.speed
        guide << u.guide
      end 
      
      # X = combine speed and guide into one 2-d array
      # =>Update the Gaussian process (using past observations) to get new means and standard errors
      # =>Okay to load all data in to model so that we're not storing model somewhere
      # =>Feed user context vector to the Gaussian process
      # =>Sample expected reward/mean and record as a tuple in an array
    end 
    # Return resources sorted by decreasing expected reward
    # TODO: Come back for infinite-armed bandit problem
  end 
  
  private
    # Remove resources that have already been interacted with by the user.
    def self.filter_out_viewed(user, resources)
      resources = resources.select do |rec|
        @interact = Interaction.find_by(user_id: user.id, resource_id: rec.id)
        if @interact.nil? 
          # Interaction doesn't exist at all
          true
        elsif @interact.helpful_q.nil? && @interact.confidence_q.nil? 
          # Interaction hasn't received feedback yet.
          true
        else
          false
        end 
      end 
    end 
    
    # Create content string for new recommendation.
    def self.generate_content(resources)
      content = ""
      resources.each_with_index do |res, index|
        if index == resources.length - 1
          content += res.id.to_s 
        else 
          content += res.id.to_s 
          content += ","
        end
      end
      content
    end 
    
    # Either save new recommendation or update existing recommendation.
    def self.save_or_update(recs)
      if (rec = Recommendation.find_by(user_id: @rec.user_id, topic_id: @rec.topic_id)).nil?
        @rec.save
      else
        rec.update(content: @rec.content)
      end 
    end 
  
  
end
