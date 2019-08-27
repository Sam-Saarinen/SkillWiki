require 'test_helper'
include ApplicationHelper

class InitializeTopicTest < ActionDispatch::IntegrationTest
  setup do
    @eric = User.find(1)
    sign_in @eric 
  end
  
 test "should create initialize resources approve new topic" do 
   
    assert_difference('Topic.count') do
      post '/topics/create', params: { topic: { name: "Heap Sort", description: "A new sorting algorithm for testing"  } }
    end

    assert_redirected_to "/topics/4/initial_resources"
    
    assert_difference 'Resource.count', WebScraperOptions[:numSearchResults] do 
      get "/topics/4/initial_resources"
    end 
    
    checkboxes = {}
    start_id = Resource.last.id - WebScraperOptions[:numSearchResults] + 1
    (start_id..start_id + WebScraperOptions[:numSearchResults] - 1).each do |i|
      checkboxes["#{i}"] = "false"
    end
    checkboxes["#{start_id}"] = "true"
    checkboxes["#{start_id + WebScraperOptions[:numSearchResults] - 1}"] = "true"
    
    assert_difference 'Resource.count', -(WebScraperOptions[:numSearchResults] - 2) do 
      post '/resources/initial', params: { "resources"=> checkboxes, "commit"=>"Create Resources" }
    end 
    assert_redirected_to approve_topics_url
    
    post "/topics/approve_or_destroy/4", params: { "todo"=>"approve", "topic_id"=>"4" }
    assert_redirected_to approve_topics_url
    
    t = Topic.find(4)
    assert t.approved 
  end 
end
