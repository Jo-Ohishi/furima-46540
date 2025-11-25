Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  get 'items/index'
  root to: "items#index"
  resources :categories, only: [] do
    resources :items, only: [:index, :new, :create]
  end
  resources :items, only: [:index, :create, :new, :show, :edit, :update, :destroy ]
  resources :items do
    resources :orders, only:[:index, :create]
  end
  resources :users, only: [:show]
end