Rails.application.routes.draw do
  devise_for :users
  root to: 'channels#show'
  resources :channels, only: [ :show ]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :channels, only: [] do
        resources :messages, only: [ :index, :create ]
      end
    end
  end
end
