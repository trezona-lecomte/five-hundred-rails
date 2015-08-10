Rails.application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  devise_for :user, only: []

  resource :login, only: [:create], controller: :sessions

  resources :games, only: [:index, :show, :create, :update], shallow: true do
    resources :rounds, only: [:show] do
      resources :bids, only: [:index, :create]
    end
  end


  match "*all", to: "application#index", via: [:get]
end
