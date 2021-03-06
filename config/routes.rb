Rails.application.routes.draw do
  resources :emails
  resources :profiles
  resources :emails
  resources :reminds do
    collection do
      delete 'destroy_multiple'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'startpage#index' #root page
  
  devise_for :users, :path_prefix => 'd'
  resources :users
  
  match '/users', to: 'users#index', via: 'get' #show list of user for admin
  match '/users/:id', to: 'users#show', via: 'get' #allows to view your own account
  
  get '/checkprofile' => 'profiles#checkprofile' #route to checkprofile method
  get '/completed' => 'reminds#completed'
  get '/listallreminders' => 'search#list_all_reminders'
  get '/listallsentreminders' => 'search#list_all_sent_reminders'
  
  ### Contact us form route ###
  match '/contacts',     to: 'contacts#new',             via: 'get'
  resources "contacts", only: [:new, :create]
  
end
