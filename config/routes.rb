Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :products, only: %i[show new create edit update destroy]
  resources :stocks
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check

  authenticated :user do
    root 'stocks#index', as: :authenticated_root
  end

  root 'home#index'
end
