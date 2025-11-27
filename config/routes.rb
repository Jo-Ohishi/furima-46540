Rails.application.routes.draw do
  devise_for :users
  get 'items/index'
  root to: "items#index" 
  # resources :categories do
  #   resources :items, only: [:index, :new, :create]
  # end
  resources :items, only: [:index, :create, :new]
end