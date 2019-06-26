Rails.application.routes.draw do
  resources :resources, except: :index
  get 'user_features/:id', to: 'user_features#show'
  get '/user_features/:id/edit', to: 'user_features#edit'
  patch '/user_features/:id', to: 'user_features#update'
  get 'topics/show/:topic_id', to: 'topics#show', as: :show_topic
  get 'topics/new'
  get 'topics/approve/', to: 'topics#approve', as: :approve_topics
  post 'topics/approve_or_destroy/:topic_id', to: 'topics#approve_or_destroy'
  post 'resources/eval', to: 'resources#eval'
  post 'resources/check_link', to: 'resources#check_link'
  post 'resources/parse_markdown', to: 'resources#parse_markdown'
  post 'topics/create', as: :topics
  get 'topics/edit'
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
