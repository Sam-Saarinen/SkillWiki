Rails.application.routes.draw do
  resources :resources, except: :index
  # get 'resources/:topic_id', to: 'resources#index', as: :topic_resource
  get 'topics/:topic_id', to: 'topics#show', as: :show_topic
  get 'topics/new'
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
