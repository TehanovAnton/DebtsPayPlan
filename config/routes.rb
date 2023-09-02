Rails.application.routes.draw do
  devise_for :users

  root to: "groups#index"
  
  resources :users do
    resources :groups do
      # TODO: make its own resources
      resources :costs

      member do
        post :add_user_member
      end
    end
  end

  resources :groups do
    member do
      get :add_user_member_show
      post :add_user_member
    end

    resources :debt_steps
  end
end
