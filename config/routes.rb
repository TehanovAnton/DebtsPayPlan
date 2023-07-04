Rails.application.routes.draw do
  resources :groups do
    resources :users do
      resources :costs
    end
  end
end
