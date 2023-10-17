# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'
  delete 'files/:id/purge', to: 'files#purge', as: 'purge_file'

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

  mount ActionCable.server => '/cable'
end
