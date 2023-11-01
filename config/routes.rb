# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  delete 'files/:id/purge', to: 'files#purge', as: 'purge_file'

  post 'users/set_email', to: 'users#set_email', as: 'set_email'

  concern :votable do
    member do
      post :vote
    end
  end

  concern :commentable do
    member do
      post :add_comment
    end
  end

  resources :rewards, only: :index

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create update destroy] do
      post :mark_the_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  mount ActionCable.server => '/cable'
end
