# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  use_doorkeeper

  # authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  # end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  delete 'files/:id/purge', to: 'files#purge', as: 'purge_file'

  post 'users/set_email', to: 'users#set_email', as: 'set_email'

  get 'search', to: 'search#index', as: 'search'

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
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show update create destroy], shallow: true do
        resources :answers, only: %i[index show update create destroy], shallow: true
      end
    end
  end

  resource :subscription, only: %i[create destroy]

  mount ActionCable.server => '/cable'
end
