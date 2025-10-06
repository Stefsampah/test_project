Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'check_user', to: 'tests#check_user'
  
  # Route temporaire pour gérer les anciens liens GET vers sign_out
  get '/users/sign_out', to: 'application#sign_out_redirect'

  # Routes pour le profil
  resource :profile, only: [:show, :edit, :update]
  get 'simplified_stats', to: 'users#simplified_stats', as: :simplified_stats

  # Routes pour les badges
  resources :badges, only: [:index, :show]
  get 'my_badges', to: 'badges#my_badges'
  get 'all_badges', to: 'badges#all_badges'

  get 'playlists', to: 'playlists#index'
  resources :playlists, only: [:show] do
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
  resources :swipes, only: [:create] do
    collection do
      get :next_video
      get :game_completion_status
    end
  end

  namespace :admin do
    resources :playlists, only: [:new, :create]
  end

  # Routes pour les badges
  resources :badges, only: [:index, :show]
  get 'my_badges', to: 'badges#my_badges'
  get 'all_badges', to: 'badges#all_badges'

  # Routes pour les récompenses
  resources :rewards, only: [:index, :show] do
    member do
      get :video_details
      get :exclusif_content
    end
    collection do
      post :unlock
    end
  end
  get 'my_rewards', to: 'rewards#my_rewards'
  get 'all_rewards', to: 'rewards#all_rewards'
  get 'reward_details', to: 'rewards#reward_details', as: :reward_details
  get 'test_details', to: 'rewards#test_details', as: :test_details
  get 'test_action', to: 'test#test_action', as: :test_action
  get 'test_rewards', to: 'test#test_rewards', as: :test_rewards
  get 'challenge_rewards', to: 'rewards#challenge', as: :challenge_rewards
  get 'partners', to: 'rewards#partners', as: :partners
  get 'exclusif_rewards', to: 'rewards#exclusif', as: :exclusif_rewards


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
  
  # Routes Stripe Checkout
  get 'store/success', to: 'store#success', as: :store_success
  get 'store/cancel', to: 'store#cancel', as: :store_cancel
  
  # Gestion des abonnements VIP
  get 'subscriptions', to: 'subscriptions#index'
  get 'subscriptions/checkout', to: 'subscriptions#checkout'
  get 'subscriptions/renewed', to: 'subscriptions#renewed'
  get 'api/subscriptions/:user_id/status', to: 'subscriptions#status'
  
  # Routes pour les tests
  post 'store/purchase_points', to: 'store#purchase_points', as: :purchase_points_store
  post 'store/unlock_playlist', to: 'store#unlock_playlist', as: :unlock_playlist_store
  post 'store/unlock_exclusive_content', to: 'store#unlock_exclusive_content', as: :unlock_exclusive_content_store
end
