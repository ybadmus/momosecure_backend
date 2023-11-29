# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API Routes
  # namespace :api, path: RoutesConfig.api_path, constraints: { subdomain: RoutesConfig.api_subdomain } do
  namespace :api do
    namespace :v1 do
      resources :user_auths, only: %i[index destroy create_admin] do
        post :create_admin, on: :collection
        patch :change_user_type, on: :collection
      end

      resources :auth, only: [] do
        collection do
          post :login
          post :verify
          post :logout
          post :login_with_verify
          post :reset_verify_code
        end
      end

      resources :admins
      resources :customers, except: :index
      resources :disputes
      resources :comments
    end
  end
end
