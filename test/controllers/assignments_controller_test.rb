require 'test_helper'

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eric = users(:eric)
    @jocko = users(:jocko)
    
    sign_in @eric 
  end

  test "should get new" do
    get new_assignments_url(1)
    assert_response :success
  end

  test "should create assignment and change due date" do
    assert_difference 'Assignment.count', 2 do
      post "/classrooms/1/assignments", params: { topic_id: 2, classroom_id: 1, due_date: "2019-12-02 23:59:59".to_datetime, students: {:all => true, 2 => true, 3 => true } }
    end 
    
    a3 = Assignment.find(3)
    a4 = Assignment.find(4)
    assert a3.due_date == "2019-12-02 23:59:59".to_datetime
    assert a4.due_date == "2019-12-02 23:59:59".to_datetime
    
    a1 = Assignment.find(1)
    a2 = Assignment.find(2)
    assert a1.due_date == "2019-12-02 23:59:59".to_datetime
    assert a2.due_date == "2019-12-02 23:59:59".to_datetime
    
    assert_no_difference 'Assignment.count' do
      post "/classrooms/1/assignments", params: { topic_id: 1, classroom_id: 1, due_date: "2020-11-17 23:59:59".to_datetime, students: {:all => true, 2 => true, 3 => true } }
    end 
    
    a1 = Assignment.find(1)
    a2 = Assignment.find(2)
    assert a1.due_date == "2020-11-17 23:59:59".to_datetime
    assert a2.due_date == "2020-11-17 23:59:59".to_datetime
  end
  
  test "should get edit" do 
    get "/classrooms/1/assignments/new/topics/1/students/#{@jocko.id}/"
    assert_response :success
  end 

end
