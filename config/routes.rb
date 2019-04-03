Rails.application.routes.draw do
  root 'pages#home'
  get '/about' => 'pages#about'
  get '/contact' => 'pages#contact'
  devise_scope :user do
    get '/sign_up', to: "devise/registrations#new"
    # get '/login', to:"devise/sessions#new"
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
