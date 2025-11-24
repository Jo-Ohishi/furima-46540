Rails.application.routes.draw do
  get 'items/index'
  root to: "items#index" 
<<<<<<< Updated upstream
  resources :items, only: [:index]
=======
  resources :items, only: [:index, :create, :new, :show]
>>>>>>> Stashed changes
end
