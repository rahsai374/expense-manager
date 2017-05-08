Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:invitations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, path: "auth", only: [:invitations],
    controllers: { invitations: 'invitations' }

  resources :expenses do
    member do
      put :update_group_expenses
    end
    collection do
      get :group_expenses
      post :pay_amount_user
      put :settle_up
    end
  end

  resources :groups do
    member do 
      post :add_member_to_group 
    end
  end

  root to: 'devise_token_auth/registrations#create'
end
