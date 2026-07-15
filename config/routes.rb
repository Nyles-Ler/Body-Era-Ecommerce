Rails.application.routes.draw do
  # Feature 1.1, 1.2
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "home#index"

  get 'home/about', to: 'home#about', as: 'about'

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
end
