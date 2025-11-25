Rails.application.routes.draw do
  devise_for :users
  get 'items/index'
  root to: "items#index"
  resources :items, only: [:index, :create, :new, :show, :edit, :update, :destroy ]
  resources :orders, only:[:create]
end