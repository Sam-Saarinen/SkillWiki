class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
  # @resource = Resource.find_by(id: params[:id])
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
    @resource = Resource.new(resource_params.permit(:name, :topic_id, :link))
    @resource.user_id = current_user.id
    
    if can? :authorize, @resource
      @resource.tentative = false
    else
      @resource.tentative = true
    end 

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new, alert: 'Resource could not be created.' }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
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
  
  def eval
    set_resource
    @interact = Interaction.new(user_id: @resource.user_id, 
    resource_id: @resource.id, 
    helpful_q: params[:helpful], 
    confidence_q: params[:confident])
    
    if @interact.save
      if params[:feedback] == "done"
        redirect_to root_url, notice: "Thank you for the feedback!"
      elsif params[:feedback] == "another"
        # redirect to next resource
        @rec = Recommendation.find_by(user_id: current_user.id) # FIXME: Assumes each user has a unique rec for each topic
        @next_resource = Resource.find_by(id: next_id(@resource.id, @rec.content))
        redirect_to @next_resource
      end 
    else 
      render action: "show", alert: "Could not save feedback"
    end 
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
    
    # Finds next id in recommendations for redirect
    def next_id(cur_id, rec_content)
      ids = rec_content.split(',')
      ids.each_with_index do |val, index| 
        if val.to_i == cur_id
          return ids[index+1]
        end 
      end
    end 
end
