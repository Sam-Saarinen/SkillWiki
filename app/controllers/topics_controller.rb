class TopicsController < ApplicationController
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new(params[:topic].permit(:name, :description))
    @topic.user = current_user
    if @topic.save
      # FIXME: After topic is saved, redirect to resources instead of home.
      redirect_to root_url, notice: "Topic created!"
    else
      render action: "new", alert: "Topic could not be created"
    end
  end
  
  def update
  end

  def edit
  end
  
  def show
    @topic = Topic.find_by(id: params[:topic_id])
    @resources = @topic.resource.all
  end
end
