class User < ApplicationRecord
  Badges = { 
    1 => { :title => "Welcome!", :requirement => "Create an account" }, 
    2 => { :title => "All Systems Go", :requirement => "Complete user feature questions" },
    3 => { :title => "The Journey Begins", :requirement => "Give feedback for first resource" },
    4 => { :title => "Giving Back", :requirement => "Submit first resource" },
    5 => { :title => "Just Getting Started", :requirement => "Finish first topic" },
    6 => { :title => "Doing More Good", :requirement => "Submit 10 resources that are approved" },
    7 => { :title => "Doing the Most Good", :requirement => "Submit 100 resources that are approved" },
    8 => { :title => "Mike Drop", :requirement => "Get 100% on topic quiz" },
    9 => { :title => "Viral", :requirement => "Submitted resource with more than 100 views and more than 4.0 helpfulness average" },
    10 => { :title => "See Something, Say Something", :requirement => "Report a resource for not being relevant" }
  }
  
  UserBadges = {
    1 => { :earned => false, :earn_date => nil }, 
    2 => { :earned => false, :earn_date => nil },
    3 => { :earned => false, :earn_date => nil },
    4 => { :earned => false, :earn_date => nil },
    5 => { :earned => false, :earn_date => nil },
    6 => { :earned => false, :earn_date => nil },
    7 => { :earned => false, :earn_date => nil },
    8 => { :earned => false, :earn_date => nil },
    9 => { :earned => false, :earn_date => nil },
    10 => { :earned => false, :earn_date => nil }
  }
  attribute :badges, :text, default: "#{UserBadges.to_json}"
  # TODO: Make user's badges a separate hash with only :earned and :earn_date (too much repetition)
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
         
  # Sets specified badge for user to earned
  def add_badge(badge_id)
    puts "--- here ---"
    badges = JSON.parse(self.badges)
    badges["#{badge_id}"]["earned"] = true
    badges["#{badge_id}"]["earn_date"] = Date.current
    self.update(badges: badges.to_json)
  end 
  
  # Checks whether specified badge has been earned
  def earned(badge_id)
    badges = JSON.parse(self.badges)
    badges["#{badge_id}"]["earned"]
  end 
  
end
