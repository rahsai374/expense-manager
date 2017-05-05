Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:invitations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, path: "auth", only: [:invitations],
    controllers: { invitations: 'invitations' }

  resources :expenses
  resources :groups

  root to: 'devise_token_auth/registrations#create'
end
