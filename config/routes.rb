Rails.application.routes.draw do
  root to: 'products#index'
  devise_for :users
  resources :products, only: [:index]
  resource :cart, only: :show do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    post 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end
  resources :orders, only: [:index, :create, :show]

  resources :revo, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
  end

  get 'pages/:name', to: 'pages#index'
end
