Rails.application.routes.draw do
  namespace :platform do
    resources :books
  end

  root 'platform/books#index'
end
