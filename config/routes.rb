Rails.application.routes.draw do
  resources :stocks
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'home#index'
end
