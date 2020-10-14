Rails.application.routes.draw do
  devise_for :users
  namespace :platform do
    resources :books
  end

  root 'platform/books#index'
end
