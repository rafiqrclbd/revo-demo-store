Rails.application.routes.draw do
  root to: 'products#index'
  devise_for :users, :controllers => {registrations: :registrations}
  resources :products, only: [:index]
  resource :cart, only: :show do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    post 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end
  resources :orders, only: [:index, :create, :show] do
    resource :payu, controller: :payu, only: [:show]
  end

  resources :revo, only: [:show] do
    get :limit, to: 'revo#limit', on: :collection
    post :callback, to: 'revo#callback', on: :collection
    end

  resources :fullrevo, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
  end
end
