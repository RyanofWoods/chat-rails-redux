Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :channels, only: [ :show ]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :channels, only: [ :index, :create ] do
        resources :messages, only: [ :index, :create ]
      end
    end
  end
end
