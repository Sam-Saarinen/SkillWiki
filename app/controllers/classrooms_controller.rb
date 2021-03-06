class ClassroomsController < ApplicationController
  include ApplicationHelper
  before_action :set_classroom, only: [:show, :edit, :update, :destroy, :show_topic]

  # GET /classrooms
  # GET /classrooms.json
  def index
    @classrooms = Classroom.all
  end

  # GET /classrooms/1
  # GET /classrooms/1.json
  def show
    # TODO: Add student's view
    if initialize_stats(@classroom)
      if params[:topics] == "active"
        @assignments = @active = Assignment.where(classroom_id: @classroom.id).where("due_date > ?", Time.current)
        @student_assignments = @assignments
        @assignments = @assignments.uniq {|a| a.topic_id }
    
        # Update stats
        new_stats = JSON.parse(@classroom.stats)
        new_avg = 0
        @assignments.each do |assign|
          new_avg += new_stats["#{assign.topic_id}"]["avg_resources_viewed"]
        end 
        new_stats["active"]["avg_resources_viewed"] = new_avg
        
        highest = nil
        highest_rating = -Float::INFINITY
        lowest = nil
        lowest_rating = Float::INFINITY
        @assignments.each do |a|
          if new_stats["#{a.topic_id}"]["highest_rated_resource_rating"].nil? # In case topic doesn't have any feedback yet
            next 
          end 
          if new_stats["#{a.topic_id}"]["highest_rated_resource_rating"] > highest_rating
            highest_rating = new_stats["#{a.topic_id}"]["highest_rated_resource_rating"]
            highest = new_stats["#{a.topic_id}"]["highest_rated_resource"]
          end 
          if new_stats["#{a.topic_id}"]["lowest_rated_resource_rating"] < lowest_rating
            lowest_rating = new_stats["#{a.topic_id}"]["lowest_rated_resource_rating"]
            lowest = new_stats["#{a.topic_id}"]["lowest_rated_resource"]
          end 
        end 
        new_stats["active"]["highest_rated_resource"] = highest || nil
        new_stats["active"]["highest_rated_resource_rating"] = if highest_rating > -Float::INFINITY then highest_rating else nil end 
        new_stats["active"]["lowest_rated_resource"] = lowest || nil 
        new_stats["active"]["lowest_rated_resource_rating"] = if lowest_rating < Float::INFINITY then lowest_rating else nil end 
        
        @classroom.stats = new_stats.to_json
        @classroom.save
        
      elsif params[:topics] == "past"
        @assignments = Assignment.where(classroom_id: @classroom.id).where("due_date < ?", Time.current)
        @student_assignments = @assignments
        @active = Assignment.where(classroom_id: @classroom.id).where("due_date > ?", Time.current)
        @assignments = @assignments.uniq {|a| a.topic_id }
        
        # Update stats
        new_stats = JSON.parse(@classroom.stats)
        new_avg = 0
        @assignments.each do |assign|
          new_avg += new_stats["#{assign.topic_id}"]["avg_resources_viewed"]
        end 
        new_stats["past"]["avg_resources_viewed"] = new_avg
        
        highest = nil
        highest_rating = -Float::INFINITY
        lowest = nil
        lowest_rating = Float::INFINITY
        @assignments.each do |a|
          if new_stats["#{a.topic_id}"]["highest_rated_resource_rating"].nil? # In case resource hasn't been given any feedback yet
            next 
          end 
          if new_stats["#{a.topic_id}"]["highest_rated_resource_rating"] > highest_rating
            highest_rating = new_stats["#{a.topic_id}"]["highest_rated_resource_rating"]
            highest = new_stats["#{a.topic_id}"]["highest_rated_resource"]
          end 
          if new_stats["#{a.topic_id}"]["lowest_rated_resource_rating"] < lowest_rating
            lowest_rating = new_stats["#{a.topic_id}"]["lowest_rated_resource_rating"]
            lowest = new_stats["#{a.topic_id}"]["lowest_rated_resource"]
          end
        end 
        new_stats["active"]["highest_rated_resource"] = highest || nil
        new_stats["active"]["highest_rated_resource_rating"] = if highest_rating > -Float::INFINITY then highest_rating else nil end 
        new_stats["active"]["lowest_rated_resource"] = lowest || nil 
        new_stats["active"]["lowest_rated_resource_rating"] = if lowest_rating < Float::INFINITY then lowest_rating else nil end 
        
        @classroom.stats = new_stats.to_json
        @classroom.save
      end 
    else
      raise "Could not initialize this classroom's stats."
    end 
  end
  
  # GET /classrooms/1/topics/1
  def show_topic
    @topic = Topic.find(params[:topic_id])
    @assignments = Assignment.where(classroom_id: @classroom.id).where("topic_id =  ?", params[:topic_id])
    @active = Assignment.where(classroom_id: @classroom.id).where("due_date > ?", Time.current)
  end 
  
  # GET /classrooms/1/topics/1/enrolled/1
  def show_student_details
    @student = User.find(params[:user_id])
    @topic = Topic.find(params[:topic_id])
    @viewed = Interaction.where('user_id = ?', @student.id).where('topic_id = ?', @topic.id)
    
    quiz_status = Unirest.get "https://us-central1-edapt-quizius.cloudfunctions.net/check_status", 
    headers: { 
      api_key: "test", 
      student_id: "#{params[:user_id]}", 
      topic_id: "#{params[:topic_id]}" 
    }
    
    @cumulative = []
    @q_and_a_list = []
    quiz_status.body.each do |key, val|
      @cumulative << val["cumulative_score"]
      response = Unirest.get "https://us-central1-edapt-quizius.cloudfunctions.net/get_interaction_record", 
      headers: { 
        quiz_id: key 
      }
      @q_and_a_list << response.body
    end 
  end 
  
  # GET /classrooms/1/roster
  def roster 
    @classroom = Classroom.find(params[:id])
    @active = Assignment.where(classroom_id: @classroom.id).where("due_date > ?", Time.current)
    @students = @classroom.enrolled.select { |u| not u.teacher? }
  end 
  
  # POST /classrooms/1/remove_student/1
  def remove_student
    @classroom = Classroom.find(params[:classroom_id])
    @student = User.find(params[:student_id])
    
    # Update running averages for number of resources viewed
    new_stats = JSON.parse(@classroom.stats)
    num_students = @classroom.num_students
    new_stats.each do |key, val|
      old_avg = new_stats["#{key}"]["avg_resources_viewed"]
      i = Interaction.where(user_id: @student.id).where(topic_id: key.to_i).count
      diff = old_avg - i.fdiv(num_students)
      new_stats["#{key}"]["avg_resources_viewed"] = diff * num_students / (num_students - 1.0)
    end 
    @classroom.stats = new_stats.to_json
    
    # Remove student's assignments
    Assignment.where(classroom_id: @classroom.id).where(student_id: @student.id).destroy_all
    
    respond_to do |format|
      if @classroom.enrolled.delete(@student) && @classroom.save
        format.html { redirect_to "/classrooms/#{@classroom.id}/roster", notice: "#{@student.name} was successfully removed from this class." }
        # format.json { render :show, status: :created, location: "/classrooms/#{@classroom.id}/roster" }
      else
        format.html { render :remove_student }
        # format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end 

  # GET /classrooms/new
  def new
    @classroom = Classroom.new
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms
  # POST /classrooms.json
  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.enrolled<<(current_user)
    @classroom.user_id = current_user.id
    @classroom.join_code = SecureRandom.hex(4)

    respond_to do |format|
      if @classroom.save
        format.html { redirect_to "/classrooms/#{@classroom.id}/show/active", notice: 'Classroom was successfully created.' }
        format.json { render :show, status: :created, location: "/classrooms/#{@classroom.id}/active" }
      else
        format.html { render :new }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classrooms/1
  # PATCH/PUT /classrooms/1.json
  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html { redirect_to @classroom, notice: 'Classroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /classrooms/enroll
  def enroll 
  end 
  
  # POST /classrooms/join
  def join
    @classroom = Classroom.find_by(join_code: params[:join_code])
    
    # Update running averages for number of resources viewed
    new_stats = JSON.parse(@classroom.stats)
    num_students = @classroom.num_students
    new_stats.each do |key, val|
      old_avg = new_stats["#{key}"]["avg_resources_viewed"]
      new_stats["#{key}"]["avg_resources_viewed"] = old_avg * num_students / (num_students + 1.0)
    end 
    @classroom.stats = new_stats.to_json
    
    respond_to do |format|
      if @classroom.enrolled<<(current_user) && @classroom.save
        format.html { redirect_to "/classrooms/#{@classroom.id}/show/active", notice: 'Classroom was successfully joined.' }
        format.json { render :show, status: :created, location: "/classrooms/#{@classroom.id}/show/active" }
      else
        format.html { render :enroll }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end 

  # DELETE /classrooms/1
  # DELETE /classrooms/1.json
  def destroy
    @classroom.destroy
    respond_to do |format|
      format.html { redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # Helper methods
  def progressMessage(student_id, topic_id, classroom_id)
    progress = Interaction.where(user_id: student_id).where(topic_id: topic_id)
    total = progress.reduce(0) { |sum, p| sum + p.helpful_q }
    avg = total.fdiv(progress.length)
    if progress.length == 0
      "<span style='color: orange;'> #{ProgressMessages[:notStarted]} </span>"
    elsif avg > ProgressMessages[:doingWellThreshold]
      "<span style='color: green;'> #{ProgressMessages[:doingWell]} </span>"
    else 
      "<span style='color: red;'> #{ProgressMessages[:needHelp]} </span>"
    end 
  end 
  
  def scoreMessage(s)
    ScoreMessages[s]
  end 
  
  def quiz_taken(student_id, topic_id)
    # GET /topics/:topic_id/students/1
    response = JSON.parse({ attempts: [ { cumulative: 0.84, date: "08/04/2019", question_set_id: 1, answer_set_id: 1 } ] }.to_json)
    if response["attempts"].length > 0
      "Yes"
    else 
      "No"
    end 
  end 
  
  helper_method :progressMessage, :scoreMessage, :quiz_taken
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classroom_params
      params.require(:classroom).permit(:name)
    end
    
    # Initialize stats field if nil to a JSON array with all topics
    def initialize_stats(classroom)
      if classroom.stats.nil?
        # TODO: quiz_avg initialized to nil b/c no quiz integration yet
        # Resources are stored by ids
        new_stats = { 
          active: { quiz_avg: nil, avg_resources_viewed: 0, highest_rated_resource: nil, highest_rated_resource_rating: nil, lowest_rated_resource: nil, lowest_rated_resource_rating: nil },
          past: { quiz_avg: nil, avg_resources_viewed: 0, highest_rated_resource: nil, highest_rated_resource_rating: nil, lowest_rated_resource: nil, lowest_rated_resource_rating: nil }
        }
        new_stats = new_stats.to_json
        classroom.stats = new_stats
        classroom.save 
      else 
        true 
      end
    end 
    
end
