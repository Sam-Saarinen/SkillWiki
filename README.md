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
    * [X] Quiz API
        * API key and student_id are paired up
        * GET /topics/:topic_id/questions { student_id: 1 }
            * Will tell Skillwiki order of contribute and quiz pages (could also be step by step)  
          * Pass in student id to personalize questions 
            * Returns list of questions for topic in following format:
                * { questions: 
                * [ { id: 1, type: "multiple choice", prompt: "What is...?", choices: ["quicksort", "mergesort"] },
                * { id: 2, type: "free response", prompt: "What is...?"} ]
                * contribute_first: true } 
        * POST /topics/:topic_id/scores { api_key: ..., student_id: 1, answers: [ { id: 1, submission: "quicksort") } ] }
            * Returns list of scores for each question { cumulative: 1.1, scores: [ { id: 1, score: 1} ] }
            * Cumulative score signifies whether topic is completed (>=1 means completed and else means incomplete)
              * No max on cumulative score
            * Score from 4 categories: right, partial, wrong, not graded
            * Post request to create record of student's attempt in server
            * On Skillwiki side, only give question feedback if cumulative is >= 1
        * GET /topics/:topic_id/students/1
            * Returns list of quiz attempts for student in topic:
                * { attempts: [ { cumulative: 0.84, date: 08/04/2019, question_set_id: 1, answer_set_id: 1 } ] }
        * GET /questions/:question_set_id
            *  Returns a set of questions in this format: { questions: 
                * [ { id: 1, type: "multiple choice", prompt: "What is...?", choices: ["quicksort", "mergesort"] }, 
                * { id: 2, type: "free response", prompt: "What is...?"} ] }
        * GET /answers/:answer_set_id
            * Returns a set of student submissions in this format:  { submissions: 
                * [ { id: 1, submission: "quicksort" }, 
                * { id: 2, type: "free response", submission: "..." ] }
        * POST /questions/topics/:topic_id
            * { submissions: [  
                * {type: "multiple choice", prompt: "What is...?", choices: ["quicksort", "mergesort"] },
                * {type: "free response", prompt: "Describe..."} ] } 
            * Creates questions for topic (for crowdsourcing questions)
        * Look up authentication methods for API keys
    * [] Fix broken tests
    * [X] Submit button for contribute question asks user to either go directly to quiz or contribute another question (reload page after submitting)
        * [X] Change text on popup box buttons so that behavior is clear  
    * [X] Edit API so that order of quiz and contributing a question are determined by API
        * Order is a function of the quiz, student features, etc.  
    * [X] Add explanation for 'Contribute a Question' page
        * e.g. "To indicate understanding of topic, submit a question that illustrates something that was interesting or difficult about this topic"
    * [] Deploy for demo on Wednesday (use Heroku?)
        * [X] Make sure seed for db is set up correctly 
        * [X] Add admin account in seed
        * [X] Go through website for bugs
    * [] Integrate first API endpoint 
    * Demo Notes
        * Dropdown for Active topics needs to be clicked twice
    * [] PyCall::PythonNotFound (PyCall::PythonNotFound) error on Heroku when create initial resources 
    * 
    * For badges, put checkmark to show that badge has been earned (Optional)
    * Change CSS for headers so that h1 is clearly different from h2, h3, etc.
    * After topic creation, alert should mention topic must be approved (b/c user may be confused)
    * HTML/CSS tutorial
    * Ability to review resources is imp.
* Badges to add:



