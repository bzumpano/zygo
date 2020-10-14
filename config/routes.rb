Rails.application.routes.draw do
  devise_for :users

  resources :books, except: :show

  root 'books#index'
end
