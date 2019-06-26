require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
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
  
  test "should get logged_in_home and then not_logged_in_home" do
    sign_in @user1
    get root_url
    assert_response :success
    # TODO: Add assert_select to differentiate between logged_in_home and not_logged_in_home
    
    sign_out @user1
    get root_url
    assert_response :success
    assert_select "h1", 1
  end
  
  # test "should be redirected to edit user features" do
  #   sign_in @user2
  #   get root_url
  #   assert_response :success
  #   assert_select "h1", "Edit User Features"
  # end 

end
