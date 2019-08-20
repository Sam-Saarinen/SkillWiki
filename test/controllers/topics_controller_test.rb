# require 'test_helper'

# class TopicsControllerTest < ActionDispatch::IntegrationTest
  
#   setup do
#     @topic1 = topics(:one)
#     @topic2 = topics(:two)
#     @user1 = users(:one)
#     @user2 = users(:two)
#     sign_in @user1
#   end
  
#   test "should get topic new" do
#     get '/topics/new'
#     assert_response :success
#   end

#   test "should get topic show" do
#     get '/topics/show/2'
#     assert_response :success
#     assert_select "ol"
#   end
  
#   test "should get topic approve" do 
#     get '/topics/approve'
#     assert_response :success
#   end 
  
#   test "should create topic" do 
#     assert_difference('Topic.count') do
#       post '/topics/create', params: { topic: { name: "QuickSort", description: "Another sorting algorithm"  } }
#     end
#     assert_redirected_to root_url
#   end 
  
#   test "should not be able to create topic" do 
#     sign_out @user1
#     sign_in @user2
#     post '/topics/create', params: { topic: {name: "QuickSort", description: "Another sorting algorithm"  } }
#     assert_redirected_to root_url 
#   end 
  
#   test "should approve topic" do 
#     assert_not @topic2.approved
#     assert_not @topic2.reviewed
#     post '/topics/approve_or_destroy/2', params: { todo: "approve" }
#     assert_redirected_to approve_topics_url
#     t = Topic.find(2)
#     assert t.approved
#     assert t.reviewed
#   end 
  
#   test "should unapprove topic" do 
#     assert_not @topic2.approved
#     assert_not @topic2.reviewed
#     post '/topics/approve_or_destroy/2', params: { todo: "unapprove" }
#     assert_redirected_to approve_topics_url
#     t = Topic.find(2)
#     assert_not t.approved
#     assert t.reviewed
#   end 

# end
