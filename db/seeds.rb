# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create users
User.create(name: "Eric", admin: true, teacher: true, email: "eric@example.com", password: "password", confirmed_at: Time.current)
User.create(name: "Scraper", admin: true, teacher: false, email: "scraper@example.com", password: "password", confirmed_at: Time.current)
User.create(name: "Jocko", admin: false, teacher: false, email: "jocko@example.com", password: "password", confirmed_at: Time.current)

# Create topics
Topic.create(name: "Bubble Sort", approved: true, description: "A sorting algorithm", user_id: 1, reviewed: true)
Topic.create(name: "Quick Sort", approved: true, description: "Another sorting algo", user_id: 1, reviewed: true)
Topic.create(name: "Merge Sort", approved: false, description: "Another sorting algo", user_id: 1, reviewed: false)

# Create classrooms
Classroom.create(name: "PHIL1590", user_id: 1, join_code: "394c0200")

# Create resource for Bubble Sort
# content = { link: "python.org", video: "", text: "" }.to_json
# Resource.create(name: "Python", topic_id: 1, user_id: 1, content: content, tentative: true)

# Add teacher to PHIL1590
u = User.find(1)
c = Classroom.find(1)
c.enrolled << (u)

# Add students
u2 = User.find(2)
u3 = User.find(3)
c.enrolled << (u2)
c.enrolled << (u3)

# Add assignments
a1 = Assignment.new(topic_id: 1, due_date: "2019-12-02 23:59:59".to_datetime)
a1.classroom = c
a1.teacher = u 

a2 = a1.dup

a1.student = u2
a2.student = u3

new_stats = { 
          active: { quiz_avg: nil, avg_resources_viewed: 0, highest_rated_resource: nil, highest_rated_resource_rating: nil, lowest_rated_resource: nil, lowest_rated_resource_rating: nil },
          past: { quiz_avg: nil, avg_resources_viewed: 0, highest_rated_resource: nil, highest_rated_resource_rating: nil, lowest_rated_resource: nil, lowest_rated_resource_rating: nil }
        }
new_stats["1"] = { 
      quiz_avg: nil, 
      avg_resources_viewed: 0, 
      highest_rated_resource: nil,
      highest_rated_resource_rating: nil,
      lowest_rated_resource: nil,
      lowest_rated_resource_rating: nil 
}
c.stats = new_stats.to_json

a1.save 
a2.save 
c.save 

puts "All seeded!"