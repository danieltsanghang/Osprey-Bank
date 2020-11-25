Rails.application.routes.draw do

  # Login and logout routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
# allow user data to be pulled for user/show
  resources :users
end
