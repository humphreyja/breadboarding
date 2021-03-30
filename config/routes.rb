Rails.application.routes.draw do
  root to: "pages#home"
  
  get :terms_of_service, to: 'pages#terms_of_service'
  get :privacy_policy, to: 'pages#privacy_policy'
  
  resource :sign_up, only: [:show] do
    get :complete, on: :member
    get :not_happening, on: :member
  end
  namespace :sign_ups, path: 'sign_up' do
    resource :email_address, only: [:new, :create]
    resource :password, only: [:new, :create]
    resource :user_rights, only: [:show, :update]
  end
  
  resource :theme, only: [:update]
  
  get :sign_in, to: 'sessions#new'
  post :sign_in, to: 'sessions#create'
  delete :sign_out, to: 'sessions#destroy'
  
  namespace :identities, path: 'identity' do
    resource :password_reset, only: [:new, :create, :show, :edit, :update] do
      get :complete, on: :member
    end
  end
  
  resources :breadboards do
    get :delete_request, on: :member
    resources :places, only: [:new, :edit, :create, :update, :destroy]
  end
end
