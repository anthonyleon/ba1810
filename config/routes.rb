Rails.application.routes.draw do

  resources :engines
  resources :aircrafts
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  root 'session#new'

  get 'signup' => 'company#new'
  get 'login' => 'session#new'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy'
#
  get '/auctions/:id/set_auction_to_false' => 'auctions#set_auction_to_false', as: 'set_auction_to_false'
  post 'auctions/:auction_id/bids/:id/purchase' => 'auctions#purchase', as: 'auction_purchase'
  get 'auctions/:auction_id/bids/:id/purchase' => 'auctions#purchase_confirmation', as: 'auction_purchase_confirmation'

  get 'sales' => 'companies#sales', as: 'sales'
  get 'purchases' => 'companies#purchases', as: 'purchases'
  get 'home' => 'companies#show', as: 'company'
  get 'company/edit' => 'companies#edit', as: 'edit_company'

  resources :inventory_parts do
    resources :documents, shallow: true
  end


  resources :auctions do
    resources :auction_parts
    resources :bids
  end

  resources :companies, except: [:index, :show, :edit] do
    resources :inventory_parts do
      collection { post :import }
    end
    member do
      get :confirm_email
    end
  end

  resources :charges

  # resources :companies do
  #   member do
  #     get :confirm_email
  #   end
  # end



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
