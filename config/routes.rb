Rails.application.routes.draw do
  devise_for :users
  root 'playlists#index'
  get 'check_user', to: 'tests#check_user'

  # Routes pour le profil
  resource :profile, only: [:edit, :update]

  # Routes pour les badges
  resources :badges, only: [:index, :show]
  get 'my_badges', to: 'badges#my_badges'
  get 'all_badges', to: 'badges#all_badges'
  post 'claim_reward/:id', to: 'badges#claim_reward', as: :claim_reward

  resources :playlists, only: [:index, :show] do
    resources :games, only: [:new, :create, :show] do
      member do
        post :swipe
        get :results
      end
      collection do
        get :play, to: "games#play", as: :play
      end
    end
  end
  
  resources :scores, only: [:index, :show]
  resources :swipes, only: [:create]

  namespace :admin do
    resources :playlists, only: [:new, :create]
  end

  # Routes pour les récompenses
  resources :rewards, only: [:index] do
    member do
      post :claim
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get 'debug_check', to: 'tests#check_user'

  # Boutique
  get  'store', to: 'store#index', as: :store
  post 'store/buy_points', to: 'store#buy_points', as: :buy_points_store
  post 'store/buy_subscription', to: 'store#buy_subscription', as: :buy_subscription_store
  get  'store/buy_playlist/:playlist_id', to: 'store#buy_playlist', as: :buy_playlist_store
  post 'store/confirm_playlist_purchase/:playlist_id', to: 'store#confirm_playlist_purchase', as: :confirm_playlist_purchase_store
end
