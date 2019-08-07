class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :update, :destroy]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
  end

  # GET classrooms/1/assignments/new
  def new
    @assignment = Assignment.new
    # @classroom = Classroom.find(params[:classroom_id])
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find_by(classroom_id: params[:classroom_id], topic_id: params[:topic_id], student_id: params[:student_id])
  end
  
  # POST /assignments/dup_message
  # Returns message for student based on whether existing assignment has been completed
  def dup_message
    a = Assignment.find_by(classroom_id: params[:classroom_id], topic_id: params[:topic_id], student_id: params[:student_id])
    if a.quiz_score.nil? # FIXME: Completion condition is some quiz score for now
      msg = " (Topic already due #{a.due_date.strftime("%a, %B %d %Y")})"
      toSend = [msg]
      render :json => toSend.to_json
    else 
      msg = " (Topic already completed)"
      toSend = [msg]
      render :json => toSend.to_json
    end 
  end 
  
  # POST /assignments/dup_assignments
  # Checks if any of the assignments to be created already exist
  def dup_assignments
    possible_dups = Assignment.where(classroom_id: params[:classroom_id]).where(topic_id: params[:topic_id])
    possible_dups = possible_dups.map {|dup| dup.student_id}
    msg = []
    params[:checked].each do |id|
      if id == "all"
        next
      end 
      if possible_dups.include? id.to_i
        msg << true
      else 
        msg << false 
      end 
    end
    render :json => msg.to_json
  end 

  # POST /classrooms/1/assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.due_date = params[:due_date].to_datetime
    @classroom = Classroom.find(params[:classroom_id])
    @assignment.classroom = @classroom
    @assignment.teacher = User.find(@assignment.classroom.user_id)
    
    assignments = []
    # iterate
    params[:students].each do |id, val|
      if id == "all"
        next 
      end 
      if val == "true"
        a = Assignment.find_by(classroom_id: params[:classroom_id], topic_id: params[:topic_id], student_id: id)
        if a.nil?
          assignment = @assignment.dup
          assignment.student = User.find(id)
          assignments << assignment.as_json
        else 
          a.due_date = @assignment.due_date
          a.save
        end 
      end 
    end 
    
    # Add topic to classroom if not already added
    new_stats = JSON.parse(@classroom.stats)
    if not new_stats.key?("#{params[:topic_id]}")
      new_stats[params[:topic_id]] = { quiz_avg: nil, 
      avg_resources_viewed: 0, 
      highest_rated_resource: nil,
      highest_rated_resource_rating: nil,
      lowest_rated_resource: nil,
      lowest_rated_resource_rating: nil }
      @classroom.stats = new_stats.to_json
    end 
    
    respond_to do |format|
      if Assignment.create(assignments) && @classroom.save
        format.html { redirect_to "/classrooms/#{params[:classroom_id]}/active", notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.permit(:topic_id)
    end
end
