Esite::Application.routes.draw do
  resources :todo_shares
  resources :todos
  resources :users
  resources :sessions

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "reset_password" => "sessions#reset_password", :as => "reset_password"


  match 'make_completed/:id/:step' => 'todos#make_completed', :as => :make_completed
  match 'add_todo' => 'todos#index', :as => :add_todo
  match 'add_shared_list' => 'todos#index', :as => :add_shared_list
  match "reset_password_save" => "sessions#reset_password_save", :as => "reset_password_save"
  match "change_password" => "sessions#change_password", :as => "change_password"
  match 'stop_share_list/:id' => 'todos#stop_share_list', :as => :stop_share_list
  match 'destroy_todo/:id' => 'todos#destroy_todo', :as => :destroy_todo
  match 'destroy_completed_todo/:id' => 'todos#destroy_completed_todo', :as => :destroy_completed_todo



  root :to => "users#new"


  #match 'shared_list' => 'todos#shared_list', :as => :shared_list
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
  # match ':controller(/:action(/:id))(.:format)'
end
