Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  get 'items/index'
  root to: "items#index" 
  get 'users/show'
  resources :items, only: [:index, :create, :new, :show, :edit, :update, :destroy]
  resources :users, only: [:show]
    # root to: 'orders#index'
  resources :orders, only:[:create]
end