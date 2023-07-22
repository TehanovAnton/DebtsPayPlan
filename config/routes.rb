Rails.application.routes.draw do
  resources :users do
    resources :groups do
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
