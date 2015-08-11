Rails.application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  devise_for :users, only: [] # disable devise routes
  resources  :users, only: [:create, :show]
  resource   :login, only: [:create], controller: :sessions

  resources :games, only: [:index, :show, :create, :update], shallow: true do
    resources :players, only: [:index, :show, :create]
    resources :rounds, only: [:show] do
      resources :bids, only: [:index, :create]
      resources :tricks, only: [:show]
    end
  end


  match "*all", to: "application#index", via: [:get]
end
