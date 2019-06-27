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
* Implement changes discussed in front-end 
  * Use inline property for video field 
* Make one text column called 'content' and save JSON object with links, text, embed code, etc.
* How to display a resource. If providing a video and explanation of video as text, display all (video, text, webpage order) and require at least one
  * Put all these into a div with overflow scrolling to always make feedback questions visible at bottom
* Edit test for creating resource
* HTML/CSS tutorial
* Think about between AAI and LAK
