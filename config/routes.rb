Rails.application.routes.draw do
  resources :users do
    resources :groups do
      resources :costs

      member do
        post :add_user_member
      end
    end
  end
end
