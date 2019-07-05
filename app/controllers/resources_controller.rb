class ResourcesController < ApplicationController
  include ApplicationHelper
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :eval]

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @interact = Interaction.find_by(user_id: current_user.id, resource_id: @resource.id)
    if @interact.nil?
      @interact = Interaction.new(user_id: current_user.id, resource_id: @resource.id)
      @interact.save # TODO: Add way to catch error in saving.
    end 
  end

  # GET /resources/new
  def new
    @resource = Resource.new
  end

  # GET /resources/1/edit
  def edit
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params.permit(:name, :topic_id))
    @resource.user_id = current_user.id
    content = { link: params[:link], video: params[:video], text: params[:text] }
    @resource.content = content.to_json
    
    if can? :authorize, @resource
      @resource.tentative = false
    else
      @resource.tentative = true
    end 

    respond_to do |format|
      if not current_user.earned(4) && Resource.where(user_id: current_user.id).count == 0
        if @resource.save && current_user.add_badge(4)
          title = User::Badges[4][:title]
          format.html { redirect_to root_url, notice: "You've earned the #{title} badge!" }
          format.json { render :new, status: :created, location: @resource }
        else
          format.html { render :new, alert: 'Resource could not be created.' }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      else 
        if @resource.save
          format.html { redirect_to root_url, notice: 'Resource was successfully created.' }
          format.json { render :new, status: :created, location: @resource }
        else
          format.html { render :new, alert: 'Resource could not be created.' }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end 
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST /resources/eval
  def eval
    @interact = Interaction.find_by(user_id: current_user.id, resource_id: @resource.id)
    if @interact.helpful_q.nil? && @interact.confidence_q.nil?
      if @interact.update(helpful_q: params[:helpful], confidence_q: params[:confident]) && 
        @resource.update_avg(params[:helpful].to_i)
        check_feedback_badges
      else 
        render action: "show", alert: "Could not save feedback"
      end 
    
    else 
      # update interaction with new feedback
      old_val = @interact.helpful_q
      if @interact.update(helpful_q: params[:helpful], confidence_q: params[:confident]) && 
        @resource.update_avg_with_old_val(params[:helpful].to_i, old_val)
        check_feedback_badges
      else 
        render action: "show", alert: "Could not save feedback"
      end 
    end 
    
  end 
  
  # POST /resources/check_link
  def check_link
    link = params[:link]
    msg = valid_url?(link).to_json
    # puts "--- #{msg} ---"
    render :json => msg
  end 
  
  # POST /resources/parse_markdown
  def parse_markdown
    text = params[:text]
    
    # Initializes a Markdown parser
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    
    # puts "--- #{markdown.render(text)} ---"
    rendered = markdown.render(text)
    msg = { html: rendered }.to_json
    render :json => msg
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.fetch(:resource, {})
    end
    
    # Finds next id in recommendations for redirect.
    def next_id(cur_id, rec_content)
      ids = rec_content.split(',')
      ids.each_with_index do |val, index| 
        if val.to_i == cur_id
          return ids[index+1]
        end 
      end
    end 
    
    # Check for any feedback badges that might have been earned.
    def check_feedback_badges
      u = User.find(@resource.user_id)
      if (not current_user.earned(3)) && (Interaction.where(user_id: current_user.id).count == 1) && current_user.add_badge(3)
        # current_user.add_badge(3) # FIXME: Why can't this be added with '&&' for if clause?
        title = User::Badges[3][:title]
        redirect_to_home_or_next_with_msg("You've earned the #{title} badge!")
      elsif (not u.earned(9)) && @resource.feedback_count > 100 && @resource.helpful_avg > 4.0 && u.add_badge(9) 
        redirect_to_home_or_next
      else 
        redirect_to_home_or_next
      end 
    end 
    
    # Redirect after feedback to next resource or home page.
    def redirect_to_home_or_next_with_msg(success_notice)
      if params[:feedback] == "done" 
              redirect_to root_url, notice: success_notice
      elsif params[:feedback] == "another" 
          # redirect to next resource
          @rec = Recommendation.find_by(user_id: current_user.id, topic_id: @resource.topic_id) 
          # FIXME: Above assumes each user has a unique rec for each topic.
          @next_resource = Resource.find_by(id: next_id(@resource.id, @rec.content))
          if @next_resource.nil?
            redirect_to root_url, notice: success_notice
          else
            redirect_to @next_resource, notice: success_notice
          end 
      end 
    end 
    
    def redirect_to_home_or_next
      if params[:feedback] == "done"
              redirect_to root_url, notice: "Thank you for the feedback!"
      elsif params[:feedback] == "another"
          # redirect to next resource
          @rec = Recommendation.find_by(user_id: current_user.id, topic_id: @resource.topic_id) 
          # FIXME: Above assumes each user has a unique rec for each topic.
          @next_resource = Resource.find_by(id: next_id(@resource.id, @rec.content))
          if @next_resource.nil?
            redirect_to root_url, notice: "That's all we have!"
          else
            redirect_to @next_resource
          end 
      end 
    end 
      
end
