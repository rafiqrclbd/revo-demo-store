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
    post :callback, on: :collection
  end

  resources :revo_order, only: [] do
    get :iframe_v1, on: :collection
    get :online_v1, on: :collection
    get :online_v2, on: :collection
    get :factoring_v1, on: :collection
    get :factoring_precheck_v1, on: :collection
    get :status, on: :collection
  end

  match 'payu_payments', via: :all, to: redirect('/')
end
