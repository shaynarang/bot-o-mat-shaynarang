Rails.application.routes.draw do
  root to: 'robots#index'
  resources :robots
  devise_for :users
end
