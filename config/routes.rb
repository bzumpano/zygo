# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :books, except: :show do
    member do
      patch :favorite
      patch :unfavorite
    end
  end

  root 'books#index'
end
