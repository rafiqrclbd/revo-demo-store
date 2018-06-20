Rails.application.routes.draw do
  root to: 'products#index'
  devise_for :users, :controllers => {registrations: :registrations}
  resources :products, only: [:index]
  resource :cart, only: :show do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    post 'remove/:product_id', to: 'carts#remove', as: :remove_from
    post 'update_quantity/:product_id', to: 'carts#update_quantity'
  end
  resources :orders, only: [:index, :create, :show, :update] do
    resource :payu, controller: :payu, only: [:show]
  end

  resources :revo_reg, only: [] do
    get :iframe_v1, on: :collection
    get :iframe_v2, on: :collection
    get :factoring_v1, on: :collection
  end

  resources :revo, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
  end

  resources :fullrevo, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
  end

  resources :factoring, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
  end

  resources :factoring_precheck, only: [:show] do
    post :callback, to: 'revo#callback', on: :collection
    post :finish, on: :member
    post :cancel, on: :member
    post :change, on: :member
  end

  match 'payu_payments', via: :all, to: redirect('/')
end
