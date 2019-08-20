require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = User.find(1)
    @user3 = User.find(3)
  end
  
  test "should get home" do
    get root_url
    assert_response :success
  end
  
  test "should get signup" do
    get '/sign_up'
    assert_response :success
  end
  
  test "should get login" do
    get '/users/sign_in'
    assert_response :success
  end

  test "should get about" do
    get '/about'
    assert_response :success
  end
  
  test "should get contact" do
    get '/contact'
    assert_response :success
  end
  
  test "should get not_found" do
    get '/not_found'
    assert_response :success
  end

end
