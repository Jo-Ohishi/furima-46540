Rails.application.routes.draw do
  get 'items/index'
  root to: "items#index" 
  resources :items, only: [:index, :create, :new, :show]
end
