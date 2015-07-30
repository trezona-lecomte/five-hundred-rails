Rails.application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  resources :games, only: [:index, :show, :create, :update]


  match "*all", to: "application#index", via: [:get]
end
