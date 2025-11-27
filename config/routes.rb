Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  get 'items/index'
  root to: "items#index" 
  get 'users/show'
  resources :items, only: [:index, :create, :new, :show, :edit, :update, :destroy]
  resources :users, only: [:show]
  resources :items do
   resources :orders, only: [:index, :create]
  end
    # root to: 'orders#index'
end