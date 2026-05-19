Rails.application.routes.draw do
  namespace :admin do
      resources :products
      resources :stocks
      resources :users

      root to: "products#index"
    end
  resources :products, only: %i[show new create edit update destroy]
  resources :stocks
  get 'statistics', to: 'statistics#index', as: :statistics
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  patch 'users/change_password', to: 'users/passwords#update', as: :change_user_password

  get 'up' => 'rails/health#show', as: :rails_health_check

  authenticated :user do
    root 'stocks#index', as: :authenticated_root
  end

  root 'home#index'
end
