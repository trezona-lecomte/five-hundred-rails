Rails.application.routes.draw do
  match '*all', to: 'application#preflight', via: [:options]

  resources :games, except: [:new, :edit] do
    resources :players, only: [:index, :create]

    resources :rounds, only: [:index, :create, :show], shallow: true do
      resources :tricks, only: [:show, :update]
    end
  end
end
