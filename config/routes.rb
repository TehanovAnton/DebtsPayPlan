Rails.application.routes.draw do
  resources :users do
    resources :groups do
      resources :costs    
    end
  end
end
