Rails.application.routes.draw do
  get 'accounts/show'
  devise_for :users
  # Feature 1.1, 1.2
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "home#index"

  get "/about", to: "pages#show", defaults: { slug: "about" }, as: :about
  get "/contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact

  # Route for 3.1.5
  resource :account, only: [:show]
  resources :addresses, only: [:new, :create, :edit, :update]

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  resource :cart, only: [:show] do
    post :add
    patch :update
    delete :remove

  # Feature 3.1.3 Checkout process
  resource :checkout, only: [:new, :create]
  end
  resources :orders, only: [:show]

  post "/stripe/webhook",
       to: "stripe_webhooks#create",
       as: :stripe_webhook
end
