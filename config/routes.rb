Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "home#index"
  resources :employees
  
  # API
  namespace :api do
    post "orders", to: "orders#create"
    post "login", to: "auth#index"
    get "restaurants", to: "restaurants#index"
    get "products", to: "products#index"
    get "orders", to: "orders#index"
    get "order/:type/:id", to: "orders#index"
    post "order/:id/status", to: "orders#set_status"
    
  end
end
