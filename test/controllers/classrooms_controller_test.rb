require 'test_helper'

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eric = User.find(1)
    @classroom = Classroom.find(1)
    
    @scraper = User.find(2)
    @jocko = User.find(3)
    @classroom.enrolled << @eric 
    @classroom.enrolled << (@scraper)
    @classroom.enrolled << (@jocko)
    
    sign_in @eric
  end

  test "should get new" do
    get new_classroom_url
    assert_response :success
  end

  test "should create classroom" do
    assert_difference('Classroom.count') do
      post "/classrooms", params: { classroom: { name: "PHIL990V" } }
    end

    assert_redirected_to "/classrooms/2/show/active"
  end

  test "should show classroom" do
    get "/classrooms/#{@classroom.id}/show/active"
    assert_response :success
    
    get "/classrooms/#{@classroom.id}/show/past"
    assert_response :success
  end
  
  test "should show topic from classroom" do 
    get show_classroom_topics_url(1,1)
    assert_response :success
  end 
  
  test "should show student details for a topic" do 
    get "/classrooms/#{@classroom.id}/topics/1/enrolled/3"
    assert_response :success
  end 
  
  test "should show classroom roster" do 
    get "/classrooms/#{@classroom.id}/roster"
    assert_response :success
  end 
  
  test "should remove student then join student" do 
    
    # Remove Jocko 
    old_size = @classroom.enrolled.size 
    assert_difference 'Assignment.count', -1 do 
      post "/classrooms/#{@classroom.id}/remove_student/3", params: {remove: ""}
    end 
    @classroom = Classroom.find(1)
    assert @classroom.enrolled.size == old_size - 1
    assert_redirected_to "/classrooms/#{@classroom.id}/roster"
    
    # Add Jocko
    sign_out @eric 
    sign_in @jocko 
    old_size = @classroom.enrolled.size
    post "/classrooms/join", params: {join_code: @classroom.join_code}
    @classroom = Classroom.find(1)
    assert @classroom.enrolled.size == old_size + 1
    assert_redirected_to "/classrooms/#{@classroom.id}/show/active"
  end 

end
