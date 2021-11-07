Rails.application.routes.draw do
  root to: 'static#info'
  resources :robots
  devise_for :users
end
