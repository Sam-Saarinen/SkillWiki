class TopicsController < ApplicationController
  load_and_authorize_resource param_method: :sanitizer, :except => [:show]
  include WebScraper
  
  def new
    @topic = Topic.new
  end
  
  def create
    # @topic = Topic.new(params[:topic].permit(:name, :description))
    @topic.name = @topic.name.titleize
    @topic.user = current_user
    if @topic.save
      redirect_to root_url, notice: "Topic created!"
    else
      render action: "new", alert: "Topic could not be created"
    end
  end
  
  def update
    # TODO: See 'Strong Parameters' of the CanCanCan doc on how to do this properly.
  end

  def edit
  end
  
  def show
    @topic = Topic.find_by(id: params[:topic_id])
    # TODO: Get cached rec instead but also update rec if feedback has bene given since last rec.
    @resources = @topic.resource.all 
    
    if @resources.empty?
      @resources = scrape_resources(@topic)
    end 
    
    # Generate recommendation for this topic.
    @rec_resources = Recommendation.generate_with_ts_Gaussian(current_user, @topic) 
    
    # Redirect to any resource that has been viewed but not given feedback by user.
    # If redirected, the new recommendation generated above will be used.
    redirect_to_last_viewed(@resources)
    
    @past_resources = @resources.select do |rec|
      interact = Interaction.find_by(user_id: current_user.id, resource_id: rec.id)
      if interact.nil?
        false  
      else 
        if !(interact.helpful_q.nil?) && !(interact.confidence_q.nil?)
          true
        else 
          false 
        end 
      end 
    end 
  end
  
  # GET /topics/approve
  def approve
  end 
  
  # POST /topics/approve_or_destroy/:topic_id
  def approve_or_destroy
    @topic = Topic.find(params[:topic_id])
    approve_or_unapprove(params[:todo])
  end 
  
  private
    def sanitizer
      params.require(:topic).permit(:name, :description)
    end 
    
    def redirect_to_last_viewed(resources)
      resources.each do |res|
        interact = Interaction.find_by(user_id: current_user.id, resource_id: res.id)
        if interact.nil?
          next 
        elsif interact.helpful_q.nil? && interact.confidence_q.nil?
          redirect_to res, notice: "You were viewing this resource recently"
        end 
      end 
    end 
    
    def approve_or_unapprove(action)
      if action == "approve"
        @topic.reviewed = true
        @topic.approved = true 
        if @topic.save 
          redirect_to approve_topics_url, notice: "#{@topic.name} is approved!"
        else 
          redirect_to approve_topics_url, alert: "#{@topic.name} could not be approved!"
        end 
      elsif action == "unapprove"
        @topic.reviewed = true
        if @topic.save 
          redirect_to approve_topics_url, notice: "#{@topic.name} marked as unapproved!"
        else 
          redirect_to approve_topics_url, alert: "#{@topic.name} could not be marked as unapproved!"
        end 
      end 
    end 
end
