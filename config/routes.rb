Kuansim::Application.routes.draw do

  devise_for :users, only: [:sign_in]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # namespace :api, defaults: {format: 'json'} do
  #   resources :users
  # end

  post  '/users/authenticate', to: 'users#authenticate'
  get '/users/verify', to: 'users#verify'
  get '/users/profile', to: 'users#current_profile'
  post  '/collections/bookmarks', to: 'events#create'
  delete  '/collections/bookmarks/:id', to: 'events#delete'
  put '/collections/bookmarks/:id', to: 'events#update'
  get   '/collections/bookmarks', to: 'events#get_events'
  get  '/users/sign_out', to: 'users#destroy_session'
  post '/users/issues/follow', to: 'users#follow_issue'
  get '/users/issues/:id/follows', to: 'users#follows_issue?'

  ############################# ISSUE #############################
  get   '/collections/issues', to: 'issues#list_all_issues'
  get   '/collections/issues/:id', to: 'issues#timeline'
  post  '/collections/issues',  to: 'issues#create'
  put   '/collections/issues/:id', to: 'issues#update'
  delete  '/collections/issues/:id', to: 'issues#delete'
  get '/collections/issues/:id/related', to: 'issues#related'
  ############################# ISSUE #############################

  get   '/collections/bookmarks/:id', to: 'events#get_event'

  ###################### ADD TO BOOKMARK BTN ######################
  get   '/bookmarks/save', to: 'events#add_to_bookmark_btn'
  ###################### ADD TO BOOKMARK BTN ######################


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => redirect('/index.html')
  # root :to => 'static#show'

  # Have a controller just to render index.html so that
  # the ApplicationController CSRF logic is set off
  root :to => 'home#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
