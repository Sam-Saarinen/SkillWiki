Rails.application.routes.draw do
  resources :assignments, except: [:new, :create]
  resources :classrooms, except: [:show]
  resources :resources, except: :index
  
  get 'classrooms/:classroom_id/assignments/new', to: 'assignments#new', as: :new_assignments
  post 'classrooms/:classroom_id/assignments', to: 'assignments#create'
  post 'assignments/dup_assignments', to: 'assignments#dup_assignments'
  get 'classrooms/:classroom_id/assignments/new/topics/:topic_id/students/:student_id/', to: 'assignments#edit'
  post 'assignments/dup_message', to: 'assignments#dup_message'
  
  get 'classrooms/:id/show/:topics', to: 'classrooms#show'
  get 'classrooms/:id/topics/:topic_id', to: 'classrooms#show_topic', as: :show_classroom_topics
  get 'classrooms/:id/topics/:topic_id/enrolled/:user_id', to: 'classrooms#show_student_details'
  get 'classrooms/enroll', to: 'classrooms#enroll'
  post 'classrooms/join', to: 'classrooms#join'
  get 'classrooms/:id/roster', to: 'classrooms#roster'
  post 'classrooms/:classroom_id/remove_student/:student_id', to: 'classrooms#remove_student'
  
  get 'user_features/:id', to: 'user_features#show'
  get '/user_features/:id/edit', to: 'user_features#edit'
  patch '/user_features/:id', to: 'user_features#update'
  
  get 'topics/show/:topic_id', to: 'topics#show', as: :show_topic
  get 'topics/new'
  get 'topics/approve/', to: 'topics#approve', as: :approve_topics
  post 'topics/approve_or_destroy/:topic_id', to: 'topics#approve_or_destroy'
  post 'topics/create', as: :topics
  get 'topics/edit'
  get 'topics/:topic_id/quiz', to: 'topics#quiz', as: :topic_quiz
  post '/topics/:topic_id/quiz/submit', to: 'topics#submit_quiz'
  get 'topics/:topic_id/quiz/contribute_question', to: 'topics#contribute_question', as: :quiz_contribution
  post 'topics/:topic_id/quiz/contribute', to: 'topics#contribute'
  
  post 'resources/eval', to: 'resources#eval'
  post 'resources/check_link', to: 'resources#check_link'
  post 'resources/parse_markdown', to: 'resources#parse_markdown'
  
  root 'pages#home'
  get '/about' => 'pages#about'
  get '/contact' => 'pages#contact'
  get '/not_found' => 'pages#not_found'
  devise_scope :user do
    get '/sign_up', to: "devise/registrations#new"
    # get '/login', to:"devise/sessions#new"
  end
  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
