Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  match "*all", to: "application#preflight", via: [:options]

  resources :games, only: [:index, :show, :create, :update], shallow: true do
    resources :rounds, only: [:show] do
      resources :bids, only: [:index, :create]
    end
  end

  get :token, controller: "application"

  match "*all", to: "application#index", via: [:get]
end
