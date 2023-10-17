Rails.application.routes.draw do
  devise_for :users

  root to: "groups#index"
  
  get '/users/:user_id/groups/:group_id/costs/partial', to: 'costs#render_partial', as: :costs_partial

  get '/groups/:group_id/debt_steps/partial', to: 'debt_steps#render_partial', as: :debt_steps_partial
  
  resources :users do
    resources :groups, only: [:index, :show] do
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
      get :join_request_notification
      get :join_requests    
      post :add_user_member
      post :reject_join_request
    end

    resources :debt_steps
  end
end
