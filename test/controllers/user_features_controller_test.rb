require 'test_helper'

class UserFeaturesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @jocko = User.find(3)
    sign_in @jocko
  end

  test "should show user_feature" do
    get "/user_features/#{@jocko.id}"
    assert_response :success
  end

  test "should get edit" do
    get "/user_features/#{@jocko.id}/edit"
    assert_response :success
  end
  
  test "should update user_features" do
    patch "/user_features/#{@jocko.id}", params: { id: @jocko.id, speed: 3, guide: 4 }
    @jocko = User.find(3)
    assert @jocko.speed == 3
    assert @jocko.guide == 4
    
    badges = JSON.parse(@jocko.badges)
    assert badges["2"]["earned"]
    
    assert_redirected_to root_url
  end

end
