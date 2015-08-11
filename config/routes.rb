Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'pages#main'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'orders' => 'orders#index'
  get 'orders/new' => 'orders#new'
  post 'orders' => 'orders#create'
  get 'orders/:id/edit_driver' => 'orders#edit_driver', as: 'order_edit_driver'
  put 'orders/:id/assign_driver' => 'orders#assign_driver', as: 'order_assign_driver'
  put 'orders/:id/confirm' => 'orders#confirm', as: 'order_confirm'
  put 'orders/:id/close' => 'orders#close', as: 'order_close'
  get 'orders/:id/edit' => 'orders#edit', as: 'order_edit'
  put 'orders/:id/change' => 'orders#change', as: 'order_change'
  put 'orders/:id/reject' => 'orders#reject', as: 'order_reject'

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
