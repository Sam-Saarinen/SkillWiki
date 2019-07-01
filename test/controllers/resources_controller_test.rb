require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @resource = resources(:one)
    sign_in @user
  end

  test "should get new" do
    get new_resource_url
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post resources_url, params: { resource: { name: "Python", topic_id: 1 }, link: "python.org", video: "", text: "" }
    end

    assert_redirected_to root_url
  end

  test "should show resource" do
    get resource_url(@resource)
    assert_response :success
  end

  test "should evaluate resource" do 
    # TODO: Test other branches of the if statement
    post '/resources/eval', params: { id: @resource.id, helpful: "4", confident: "3", feedback: "done" }
    assert_redirected_to root_url
  end 
end
