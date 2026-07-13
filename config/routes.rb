Rails.application.routes.draw do
  root "home#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
end
