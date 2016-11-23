Rails.application.routes.draw do


  get 'errors/not_found'

  get 'errors/internal_server_error'

  get 'password_resets/new'

  resources :engines do
    resources :documents, shallow: true
  end


  resources :aircrafts do
    resources :documents, shallow: true
  end

resources :inventory_parts do
  collection do
    get 'remove_all'
  end
end

  patch "/update_transaction/:id" => 'transactions#update', as: "transaction"
  post '/receive_webhook' => 'transactions#receive_webhook', as: "webhook"
  patch 'transactions/:id' => 'transactions#create_shipment', as: "create_shipment"
  patch '/auctions/:id/purchase' => 'transactions#update_tax_shipping', as: "update_tax_shipping"
  get 'notifications/index'

  get '/invoice/:id' => 'transactions#invoice_pdf', as: 'transaction_invoice'
  get 'purchase_order/:id' => 'transactions#po', as: 'transaction_po'
  get '/material_cert/:id' => 'transactions#material_cert', as: 'material_cert'

  resources :ratings
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  root 'pages#show'

  get 'signup' => 'companies#new'
  get 'login' => 'session#new', as: 'login'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy'
#
  get '/auctions/:id/set_auction_to_false' => 'auctions#set_auction_to_false', as: 'set_auction_to_false'
  get 'auctions/:auction_id/bids/:id/purchase_confirmation' => 'auctions#purchase_confirmation', as: 'auction_purchase_confirmation'

  get 'purchase/:id/buyer_purchase' => 'transactions#buyer_purchase', as: 'buyer_purchase'
  get 'purchase/:id/seller_purchase' => 'transactions#seller_purchase', as: 'seller_purchase'

  get 'select_payout_preference' => 'companies#choose_payout_preference', as: 'select_payout_preference'
  get 'pending_sales' => 'companies#pending_sales', as: 'pending_sales'
  get 'sales' => 'companies#sales', as: 'sales'
  get 'pending_purchases' => 'companies#pending_purchases', as: 'pending_purchases'
  get 'purchases' => 'companies#purchases', as: 'purchases'
  get 'dashboard' => 'companies#show', as: 'dashboard'
  get 'company/edit' => 'companies#edit', as: 'edit_company'

  post 'payment' => 'bids#release_payment', as: 'payment'

  get 'current_opportunities' => 'auctions#current_opportunities', as: 'current_opportunities'
  get 'bids' => 'bids#index', as: 'bids'
  resources :password_resets

  resources :inventory_parts do
    resources :documents, shallow: true
  end

  resources :auctions do
    resources :auction_parts, except: [:index]
    resources :bids, except: [:index]
  end

  resources :companies, except: [:index, :show] do
    resources :ratings
    resources :inventory_parts do
      collection { post :import }
    end
  end

  get 'companies/confirm_email', to: 'companies#confirm_email', as: 'confirm_email'


  resources :company_docs

  #errors
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resource :pages, only: [:show]
  get 'pricing', to: 'pages#pricing', as: 'pricing'
  get 'features', to: 'pages#features', as: 'features'
  get 'aircraft_listing', to: 'pages#aircraft_listing', as: 'aircraft_listing'
  get 'engine_listing', to:'pages#engine_listing', as: 'engine_listing'
  get 'aircraft_show/:id', to: 'pages#aircraft_show', as: 'aircraft_show'
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
=======
  get 'engine_show/:id' => 'pages#engine_show', as: "engine_show"

>>>>>>> 52b9bb2b4ae88b37cd2d740c008369e15ce3f994
end
