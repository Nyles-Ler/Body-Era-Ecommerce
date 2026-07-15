Rails.application.routes.draw do
  root "home#index"

  get 'home/about', to: 'home#about', as: 'about'

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
end
