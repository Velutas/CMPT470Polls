Rails.application.routes.draw do
  
  post 'messaging/new'
  get 'messaging' => 'messaging#index'
  get 'message/:id' => 'messaging#show'
  post 'send' => 'messaging#send_msg'
  post 'reply' => 'messaging#reply'

  get 'friends/new'

  get 'friends/edit'

  get 'friends/show'

  get 'friends/delete'

  get 'password_resets/new'

  get 'password_resets/edit'

  resources :answers
  resources :messaging

  get 'questions/index'

  get 'question/index'

  get 'users/new'

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :articles do
    resources :comments
  end

  resources :friends

  resources :polls do
	resources :poll_comments
	resources :answers
      resources :votes
  end
  
  get 'popular' => 'polls#popular'
  
  resources :users

  # Account activation code and Password reset code sourced from railstutorial.com
  # https://www.railstutorial.org/book/account_activation_password_reset
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'users' => '404'
  
  get 'profile' => 'users#show'
  patch 'profile' => 'users#update_usertype'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'

  post 'logout' => 'sessions#destroy'
  
  get 'register' => 'users#new'
  post 'register' => 'users#create'

  get 'options' => 'users#edit'
  post 'options' => 'users#edit'
  # re-render call
  patch 'options' => 'users#update'

  get 'notifications' => 'users#notifications'

  post 'accept' => 'friends#accept'
  post 'reject' => 'friends#reject'

  post 'accept_suggestion' => 'friends#accept_suggestion'
  post 'reject_suggestion' => 'friends#reject_suggestion'

  # resources :options, :as => :users, :controller => :users, :only => [:update]

  # match '/options', :to => 'users#edit', :via => :get, :as => 'options'

  resources :votes

  resources :register do
    resources :users
  end

  root 'polls#popular'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
