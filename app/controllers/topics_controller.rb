class TopicsController < ApplicationController
  before_action :form_sanitizer, :only => [:submit_quiz]
  load_and_authorize_resource param_method: :sanitizer, :only =>[:create] # , :except => [:show, :quiz, :submit_quiz, :contribute_question, :contribute]
  include WebScraper
  
  Quizius_API_Key = "needs_to_be_added"
  
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
    topic = Topic.find(params[:topic_id])
    approve_or_unapprove(topic, params[:todo])
  end 
  
  # GET /topics/:topic_id/quiz
  def quiz
    @topic = Topic.find(params[:topic_id])
    
    # Get questions for particular user and topic from quizius 
    response = Unirest.get "https://us-central1-edapt-quizius.cloudfunctions.net/get_questions", 
    headers: {
      api_key: Quizius_API_Key, 
      student_id: "#{current_user.id}", 
      topic_id: "#{params[:topic_id]}"
    }
    
    @quizius_interact_id = response.body["interaction_id"]
    @questions = response.body["questions"]
  end 
  
  # POST/topics/:topic_id/quiz/submit
  def submit_quiz
    topic = Topic.find(params[:topic_id])
    question_types = params[:question_type]
    
    answers = []
    user_answers = params.permit(:answers)
    justifications = params.permit(:justify)
    submissions =  user_answers.merge(justifications) { |key, oldval, newval| [oldval, newval] }
    submissions.each do |key, val|
      answers << { 
        question_id: key, 
        answer_index?: (val[0] if question_types[key] == "multiple choice"),
        response_text?: (val[0] if question_types[key] == "free response"),
        rationale_text?: val[1]
      }.compact! # Only includes keys with values other than nil
    end 

    response = Unirest.get "https://us-central1-edapt-quizius.cloudfunctions.net/submit_answers", 
    headers: {
      api_key: Quizius_API_Key, 
      interaction_id: params[:quizius_interact_id],
      answers: answers
    }
    
    cumulative = response.body["cumulative_score"] 
    
    respond_to do |format|
      if cumulative >= 1.0
        format.html { redirect_to root_url, notice: "You've completed #{topic.name}!" }
        format.json { render root_url, status: :created }
      else 
        format.html { redirect_to root_url, alert: "You did not complete #{topic.name}. Try viewing some more resources and retaking the quiz." }
        format.json { render root_url, status: :created }
      end 
    end 
  end 
  
  # GET /topics/:topic_id/quiz/contribute_question
  # def contribute_question
  #   @topic = Topic.find(params[:topic_id])
  # end 
  
  # POST /topics/:topic_id/quiz/contribute
  # def contribute 
  #   toSend = { submissions: [] }
  #   q = {}
  #   q[:type] = params[:question_type]
  #   q[:prompt] = params[:prompt] 
  #   if q[:type] == "multiple choice"
  #     q[:choices] =  params[:choices].values 
  #   end 
  #   toSend[:submissions] << q

  #   # POST /questions/topics/:topic_id
  #   #         * { submissions: [  
  #   #             * {type: "multiple choice", prompt: "What is...?", choices: ["quicksort", "mergesort"] },
  #   #             * {type: "free response", prompt: "Describe..."} ] } 
  #   respond_to do |format|
  #     if params[:next] == "true"
  #       format.html { redirect_to topic_quiz_url(params[:topic_id]) }
  #       format.json { render topic_quiz_url(params[:topic_id]) }
  #     else 
  #       format.html { redirect_to "/topics/#{params[:topic_id]}/quiz/contribute_question" }
  #       format.json { render "/topics/#{params[:topic_id]}/quiz/contribute_question" }
  #     end 
  #   end 
  # end 
  
  private
    def sanitizer
      params.require(:topic).permit(:name, :description)
    end 
    
    def form_sanitizer
      params.permit(:utf8, :authenticity_token, :quizius_interact_id, :question_type, :answers, :justify, :commit, :topic_id)
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
    
    def approve_or_unapprove(topic, action)
      if action == "approve"
        topic.reviewed = true
        topic.approved = true 
        if topic.save 
          redirect_to approve_topics_url, notice: "#{topic.name} is approved!"
        else 
          redirect_to approve_topics_url, alert: "#{topic.name} could not be approved!"
        end 
      elsif action == "unapprove"
        topic.reviewed = true
        if topic.save 
          redirect_to approve_topics_url, notice: "#{topic.name} marked as unapproved!"
        else 
          redirect_to approve_topics_url, alert: "#{topic.name} could not be marked as unapproved!"
        end 
      end 
    end 
end
