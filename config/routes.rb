SimpleCms::Application.routes.draw do
  #get "authentications/login"
  #
  #get "authentications/menu"

  #get "public/index"
  #
  #get "public/show"

  #get "access/menu"
  #
  #get "access/login"

  root :to => "public#show"

  match 'admin', :to => 'authentications#menu'
  # match 'access/logout', :to => 'access#logout'
 # match 'access/login', :to => 'access#attempt_login'

  # Below: match any URL string with "show/" and send whatever is after it (:id)
  # to the "public" controller's, "show" method.
  # The ":id" will be sent to the show method in the "public" view.
  # You don't have to use ":id", you could use any word.
  ### match 'show/:id', :to => 'public#show'

  #get "demo/index"

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  ## match ':controller(/:action(/:id))(.:format)'

  # config/routes.rb
  resources :subjects do
    member do
      get :delete

    end
  end

  resources :pages do
    member do
      get :delete
    end
  end

  resources :sections do
    member do
      get :delete
    end
  end

  resources :admin_users do
    member do
      get :delete
    end
  end

  resources :authentications do
    collection do
      get 'menu'
      get 'logout'
      get 'login'
      post 'attempt_login'
    end
  end

end
