# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :webhooks do
    scope module: 'stripe', path: '/stripe', as: :stripe do
      post 'events', to: 'event#handle'
    end
  end
end
