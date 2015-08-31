Rails.application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  devise_for :users, only: [] # disable devise routes
  resources  :users, only: [:create]
  resource   :login, only: [:create], controller: :sessions

  resources :games,      only: [:index, :show, :create], shallow: true do
    resources :players,  only: [:show, :create]
    resources :rounds,   only: [:index, :show] do
      resources :bids,           only: [:index, :create]
      resources :available_bids, only: [:index]
      resources :tricks,         only: [:index, :show]
      resources :cards,          only: [:index, :update]
    end
  end

  match "*all", to: "application#index", via: [:get]
end
