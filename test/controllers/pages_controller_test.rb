require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get home" do
    get root_url
    assert_response :success
  end
  
  test "should get signup" do
    get '/sign_up'
    assert_response :success
  end
  
  test "should get login" do
    get '/login'
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
  
  test "should get logged_in_home" do
    post user_session_path, params: {user: {
    email:"example@example.com",
    password:"password"
    }}
    get root_url
    assert_response :success
    assert_select "h1", {count: 1, text: "Logged in page"}
  end

end
