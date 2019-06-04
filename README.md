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
* redirect user to preferences for questions if haven't answered them yet--create UserFeaturesController
* Goal for now: enable data gathering (adding topics and resources)
    * rails generate scaffold name (does forms automatically)
    * routes for resources are weird 
    * mockup: intermediate page after clicking on topic to display recommended resoruces first 
    * refactor later for consistency among controllers
    * link not found page has navbar still in iframe (only display text, go stil links to not_found)
    * Two buttons: 
        * "I understand the topic now", "Give me another resource" (sticky to top so always visible while viewing resource)
        * If user clicks "I understand", give a quiz. Can then evaluate how useful resource(s) were for user based on score.
        * redirecting away from resource view page: record last viewed resource to check if questions were answered 
