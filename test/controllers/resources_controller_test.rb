require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jocko = User.find(3)
    sign_in @jocko
  end

  test "should get new" do
    get new_resource_url
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post resources_url, params: { name: "Python", topic_id: 2, link: "python.org", video: "", text: "" }
    end
    badges = JSON.parse(@jocko.badges) # Don't need to reset @jocko for badges?
    assert badges["4"]["earned"]
    assert_redirected_to root_url
  end

  test "should show resource" do
    assert_difference('Interaction.count') do 
      get resource_url(1)
    end 
    assert_response :success
  end

  test "should evaluate resource" do 
    # Create new interaction
    get resource_url(1)
    post '/resources/eval', params: { id: 1, helpful: "4", confident: "3", feedback: "done" }
    
    i = Interaction.find(1)
    assert i.helpful_q == 4
    assert i.confidence_q == 3
    
    @jocko = User.find(3)
    badges = JSON.parse(@jocko.badges)
    assert badges["3"]["earned"]
    assert_redirected_to topic_quiz_url(1)
    
    # Update feedback for interaction
    get root_url
    get resource_url(1)
    post '/resources/eval', params: { id: 1, helpful: "3", confident: "4", feedback: "done" }
    
    i = Interaction.find(1)
    assert i.helpful_q == 3
    assert i.confidence_q == 4
    
    assert_redirected_to topic_quiz_url(1)
  end 
  
  test "should approve resource and remove tentative status" do
    sign_out @jocko 
    r = Resource.find(1)
    assert r.tentative
    assert_not r.approved
    
    (3..7).each do |i|
      u = User.find(i)
      sign_in u
      get resource_url(1)
      post '/resources/eval', params: { id: 1, helpful: "3", confident: "4", feedback: "done" }
      r = Resource.find(1)
      sign_out u
    end 
    
    r = Resource.find(1)
    assert_not r.tentative
    assert r.approved
  end
  
  test "should flag resource" do
    sign_out @jocko 
    r = Resource.find(1)
    assert_not r.flagged
    
    (3..7).each do |i|
      u = User.find(i)
      sign_in u
      get resource_url(1)
      post '/resources/eval', params: { id: 1, helpful: "1", confident: "4", feedback: "done" }
      r = Resource.find(1)
      sign_out u
    end 
    
    r = Resource.find(1)
    assert r.flagged
  end 
  
end
