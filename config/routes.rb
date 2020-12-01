Rails.application.routes.draw do
  
  root 'home#index'
  get 'home/index'
  
  # Login and logout routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # allow user data to be pulled for user/show
  resources :users, only: [:show, :edit, :update]

  # Create resourceful routes for transactions
  resources :transactions

  # Create resourceful routes for accounts only to show accounts, as user should not be able to do anything else
  resources :accounts
  resources :accounts, only: [:show] do
    resources :transactions, only: [:index, :new, :create]
  end

end
