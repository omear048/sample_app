SampleApp::Application.routes.draw do
  #get "users/new"
  #get "static_pages/home"
  #get "static_pages/help"
  #get "static_pages/about"
  #get "static_pages/contact"

  resources :users  do
    member do #Pg. 602 - and the member method means that the routes respond to URLs containing the user id.
      get :following, :followers #You might suspect that the URLs will look like /users/1/following and /users/1/followers, and that is exactly what the code in Listing 11.18 does. Since both pages will be showing data, we use get to arrange for the URLs to respond to GET requests (as required by the REST convention for such pages), and the member method means that the routes respond to URLs containing the user id.
    end
  end
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy] #(Pg. 541) 
  resources :relationships, only: [:create, :destroy] #(Pg. 609)
  root 'static_pages#home'      #This creates the root_path
  match '/signup',   to: 'users#new',            via: 'get'     #This creates the signup_path
  match '/signin',   to: 'sessions#new',         via: 'get'     #This creates the signin_path
  match '/signout',  to: 'sessions#destroy',     via: 'delete'  #This will delete the session; will be invoked by the HTTP DELETE request
  match '/help',     to: 'static_pages#help',    via: 'get'     #This creates the help_path
  match '/about',    to: 'static_pages#about',   via: 'get'     #This creates the about_path
  match '/contact',  to: 'static_pages#contact', via: 'get'     #This creates the contact_path


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
 
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
