require 'test_helper'

class LoggingInTest < ActionDispatch::IntegrationTest
  
  setup do
    @user1 = User.find(1)
    @user3 = User.find(3)
  end
  
  test "should get logged_in_home and then not_logged_in_home" do
    sign_in @user1
    get root_url
    assert_response :success
    assert_select "a[href=?]", destroy_user_session_path, :count => 1
    assert_select "a[href=?]", new_user_session_path, :count => 0

    sign_out @user1
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_user_session_path, :count => 1
    assert_select "a[href=?]", destroy_user_session_path, :count => 0
  end
  
  test "should be redirected to edit user features" do
    # TODO: Can't test redirect (can't test after_sign_in_path_for)
    # sign_in @user3
    # get "/user_features/#{@user3.id}/edit"
    # # assert_response :redirect, @response.body
    # assert_redirected_to(controller: "user_features", action: "edit")
  end
  
end
