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
* TOASK:
* TODO:
    * [X] Integrate rest of the quizius API endpoints
        * [X] Quiz_status endpoint 
        * [X] interaction_record endpoint 
    * [X] Edit current fixtures to match current schema 
    * [] Get current tests working (after some edits)
    * [] Flag resources by default as tentative 
    * [] Refactor CSS (get rid of in-line styling)
    * [] Get automatic approval of resources (threshold of 5 helpfulness ratings >= 3 and helpful_avg >= 2.5)
    * Joseph J Williams paper on bandit processes to select helpful explanations for quiz questions
    * 
    * 
    * For badges, put checkmark to show that badge has been earned (Optional)
    * Change CSS for headers so that h1 is clearly different from h2, h3, etc.
    * After topic creation, alert should mention topic must be approved (b/c user may be confused)
    * HTML/CSS tutorial
    * Ability to review resources is imp.
* Badges to add:



