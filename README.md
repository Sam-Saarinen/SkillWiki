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
    * Cap number of resources for a recommendation?
* TODO:
    * For badges, put checkmark to show that badge has been earned
    * Change CSS for headers so that h1 is clearly different from h2, h3, etc.
    * After topic creation, alert should mention topic must be approved (b/c user may be confused)
    * HTML/CSS tutorial
    * Add ability for filtering resources that have been web-scraped
    * Add ability to flag inappropriate resources
    * Ability to review resources is imp.
* Khan Academy Badge System Notes
    * Badge page can be navigated to from profile navbar
    * "Badges Earned" are displayed first then "Possible Badges"
    * Badges are divided into categories based on difficulty to earn
    * Each badge has its own illustration
    * Each badge displays how long ago it was earned
    * Hovering over the illustration of a badge displays the requirement to earn the badge
    * Badges may be earned multiple times and this number is displayed below the illustration
    * A link near the top of the page checks if any new badges have been earned
* Badges to add:
    1. Welcome! (Create an account)
    2. All systems go (Complete user feature questions)
    2. The journey begins (Give feedback for first resource)
    3. Giving back (Submit first resource)
    4. Just getting started (Finish first topic)
    5. Doing more good (Submit 10 resources that are approved)
    6. Doing the most good (Submit 100 resources that are approved)
    7. Mike drop (Get 100% on topic quiz)
    8. Viral (Submitted resource with > 100 feedback_count and > 4.0 helpful_avg)
    9. See Something, Say Something (Report a resource for not being relevant)

