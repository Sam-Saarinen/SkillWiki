require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @topic1 = topics(:one)
    @topic3 = topics(:three)
    @eric = users(:eric)
    @jocko = users(:jocko)
    sign_in @eric
  end
  
  test "should get topic new" do
    get '/topics/new'
    assert_response :success
  end

  test "should get topic show" do
    # TODO: Manually test this b/c I don't want to rack up the external API usage
    # assert_difference('Resource.count', 5) do
    #   get '/topics/show/2'
    # end 
    # assert_response :success
  end
  
  test "should get topic approve" do 
    get '/topics/approve'
    assert_response :success
  end 
  
  test "should create topic" do 
    assert_difference('Topic.count') do
      post '/topics/create', params: { topic: { name: "Heap Sort", description: "Another sorting algorithm for testing"  } }
    end
    assert_redirected_to root_url
  end 
  
  test "should not be able to create topic" do 
    sign_out @eric
    sign_in @jocko
    post '/topics/create', params: { topic: {name: "QuickSort", description: "Another sorting algorithm"  } }
    assert_redirected_to root_url 
  end 
  
  test "should approve topic" do 
    assert_not @topic3.approved
    assert_not @topic3.reviewed
    post '/topics/approve_or_destroy/3', params: { todo: "approve" }
    assert_redirected_to approve_topics_url
    t = Topic.find(3)
    assert t.approved
    assert t.reviewed
  end 
  
  test "should unapprove topic" do 
    assert_not @topic3.approved
    assert_not @topic3.reviewed
    post '/topics/approve_or_destroy/3', params: { todo: "unapprove" }
    assert_redirected_to approve_topics_url
    t = Topic.find(3)
    assert_not t.approved
    assert t.reviewed
  end 
  
  test "should get quiz" do 
    get topic_quiz_url(1)
    assert_response :success
  end 
  
  # TODO: Test submit_quiz manually? Since the questions are API-dependent, post 
  # params are uncertain

end
