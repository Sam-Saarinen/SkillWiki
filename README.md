# SkillWiki
Applying Reinforcement Learning to Pedagogical Adaptation

# About this document
This document is a working draft for internal use, containing notes and thoughts on implementation. As the project progresses, it will shift more to documentation.

# Gems we want to use:
## Authentication
Devise ([https://github.com/plataformatec/devise])
## User Permissions Management
cancancan ([https://github.com/CanCanCommunity/cancancan])
## Lists of Gems:
[https://rubygarage.org/blog/best-ruby-gems-we-use]
[https://vexxhost.com/resources/tutorials/10-essential-useful-ruby-on-rails-4-gems/]

# Past Issus 
## Version of sqlite3 must be specified for server to run 
gem 'sqlite3', '~> 1.3.6' 

# Things to Remember (Eric)
* For installing heroku on cloud9: (1) nvm i v8 (2) npm install -g heroku
* For resetting heroku db: heroku pg:reset
* Manual Tests:
  * Integration: log in for new user and should be redirected to 'Edit User Features'
* TOASK:
* TODO:
    * [X] Check API to see if brief excerpt from resource is available 
    * [X] Try experimenting with number of search results with API to see if we can get more relevant resources
      * Search quality rapidly drops off around 10 results
    * [X] Experiment with APIs Sam sent 
    * [X] Page for teacher to approve or remove flagged resources
    * [X] Try to get Initialize Topic test working 
    * [] Read up on papers Sam sent
    * Joseph J Williams paper on bandit processes to select helpful explanations for quiz questions
    * Active learning algos get supervised feedback at end as opposed to reinforcement learning algos that get reward at each timestep 
    * 
    * For badges, put checkmark to show that badge has been earned (Optional)
    * Change CSS for headers so that h1 is clearly different from h2, h3, etc.
    * After topic creation, alert should mention topic must be approved (b/c user may be confused)
    * HTML/CSS tutorial
    * Ability to review resources is imp.
* Badges to add:



