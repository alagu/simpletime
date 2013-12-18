TimeManager::Application.routes.draw do

  resources :tasks
  devise_for :users

  match "dashboard" => "tasks#index", :as => 'user_root'

  root :to => "home#index"
end
