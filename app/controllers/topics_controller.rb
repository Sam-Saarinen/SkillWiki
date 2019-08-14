class TopicsController < ApplicationController
  load_and_authorize_resource param_method: :sanitizer, :except => [:show, :quiz, :submit_quiz, :contribute_question, :contribute]
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
  
  # GET /topics/:topic_id/quiz
  def quiz
    @topic = Topic.find(params[:topic_id])
    # GET /topics/:topic_id/questions { student_id: current_user.id }
    # FIXME: Dummy JSON response for now
    response = { questions: 
    [ { id: 1, type: "multiple choice", prompt: "Which sorting algorithm has the worst time complexity on average?", choices: ["Heapsort", "Insertion sort", "Quicksort", "Mergesort"] },
    { id: 2, type: "multiple choice", prompt: "Which sorting algorithm has the best time complexity in the best cases?", choices: ["Heapsort", "Insertion sort", "Quicksort", "Mergesort"] },
    { id: 3, type: "free response", prompt: "Describe the time complexity of any sorting algorithm (justify your answer by accounting for the best, average, and worst case)"} ] }.to_json
    @questions = JSON.parse(response)["questions"]
  end 
  
  # POST/topics/:topic_id/quiz/submit
  def submit_quiz
    # POST /topics/:topic_id/scores { api_key: ..., student_id: 1, answers: [ { id: 1, submission: "quicksort") } ] }
    topic = Topic.find(params[:topic_id])
    toSend = { student_id: current_user.id }
    
    answers = []
    params[:answers].each do |key, val|
      answers << { id: key, submission: val }
    end 
    toSend[:answers] = answers
    
    justify = []
    params[:justify].each do |key, val|
      justify << { id: key, submission: val }
    end 
    toSend[:justify] = justify
    # toSend = toSend.to_json
    puts "--- #{toSend} ---"
    response = JSON.parse({ cumulative: 1.3, scores: [ { id: 1, score: 1} ] }.to_json)
    cumulative = response["cumulative"].to_i
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
  def contribute_question
    @topic = Topic.find(params[:topic_id])
  end 
  
  # POST /topics/:topic_id/quiz/contribute
  def contribute 
    toSend = { submissions: [] }
    q = {}
    q[:type] = params[:question_type]
    q[:prompt] = params[:prompt] 
    if q[:type] == "multiple choice"
      q[:choices] =  params[:choices].values 
    end 
    toSend[:submissions] << q

    # POST /questions/topics/:topic_id
    #         * { submissions: [  
    #             * {type: "multiple choice", prompt: "What is...?", choices: ["quicksort", "mergesort"] },
    #             * {type: "free response", prompt: "Describe..."} ] } 
    respond_to do |format|
      if params[:next] == "true"
        format.html { redirect_to topic_quiz_url(params[:topic_id]) }
        format.json { render topic_quiz_url(params[:topic_id]) }
      else 
        format.html { redirect_to "/topics/#{params[:topic_id]}/quiz/contribute_question" }
        format.json { render "/topics/#{params[:topic_id]}/quiz/contribute_question" }
      end 
    end 
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
