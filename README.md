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
    * [X] Use icon with reusable rights
    * [X] Check if changing topic when editing a resource breaks recommendations 
    * [X] Change threshold so based on percentage of interactions or people who have used this resource (for flagThreshold)
    * [X] Restrict editing the resource to people who have contributed the resource
    * [X] Remove topic, link, and video boxes if recommendation can't be updated easily 
      * Would need to reset resource history  
    * [X] Add button in show for editing resource
    * [X] 2pm retrospective
    * [] Read up on papers Sam sent
    * Joseph J Williams paper on bandit processes to select helpful explanations for quiz questions
    * Active learning algos get supervised feedback at end as opposed to reinforcement learning algos that get reward at each timestep 
    * item-response theory from psych 
    * Right-answer mining and explanation-mining for quiz generation 
    * 
    * For badges, put checkmark to show that badge has been earned (Optional)
    * Change CSS for headers so that h1 is clearly different from h2, h3, etc.
    * After topic creation, alert should mention topic must be approved (b/c user may be confused)
    * HTML/CSS tutorial
    * Ability to review resources is imp.
* Badges to add:



