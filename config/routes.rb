require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users
	resources :auctions do
  	get :autocomplete_company_name, :on => :collection
	end

	get '/auction_invite/:auction_id/invitee' => 'session#invite_login', as: 'invite_existing_user'
	get 'projects/archive'

	resources :projects do
		resources :auctions, only: [:import] do
			collection { post :import }
		end
	end

	get 'admin_inventory_upload' => 'companies#admin_inventory_upload', as: 'admin_inventory_upload'
	get 'parts/new'

	get 'errors/not_found'

	get 'errors/internal_server_error'

	get 'password_resets/new'
	get '/privacy_policy' => 'pages#privacy_policy', as: 'privacy_policy'

	get '/terms_and_conditions' => 'pages#terms_and_conditions', as: 'terms_and_conditions'

	get '/contact_us' => 'pages#sign_up_form', as: 'sign_up_form'

	resources :documents, only: [:new, :index, :create, :destroy]

	post '/contact_us' => 'pages#new_lead', as: 'new_lead'

	get "/sitemap.xml" => "pages#sitemap", format: "xml", :as => :sitemap

	get "/sitemapindex.xml" => "pages#sitemapindex", format: "xml", :as => :sitemapindex

	get '/about' => 'pages#about', as: 'about_us'

	get 'part/:part_num' => 'pages#inventory_part', as: 'sitemap_inventory'

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

	get "/transaction/:id" => "transactions#show", as: "transaction"
	post "/transaction" => "transactions#create", as: "transactions"

	patch "/transaction/:id" => 'transactions#update'
	
	post '/receive_webhook' => 'transactions#receive_webhook', as: "webhook"
	patch 'transactions/:id' => 'transactions#create_shipment', as: "create_shipment"
	patch '/purchase/:id/seller_purchase' => 'transactions#send_invoice', as: "send_invoice"


	get '/invoice/:id' => 'transactions#invoice_pdf', as: 'transaction_invoice'
	get 'purchase_order/:id' => 'transactions#po', as: 'transaction_po'
	get '/material_cert/:id' => 'transactions#material_cert', as: 'material_cert'

	get 'purchase/:id/buyer_purchase' => 'transactions#buyer_purchase', as: 'buyer_purchase'
	get 'purchase/:id/seller_purchase' => 'transactions#seller_purchase', as: 'seller_purchase'


	post 'record_purchase' => 'transactions#record', as: 'record_transaction'
	delete 'remove_transaction' => 'transactions#remove_from_purchase_history', as: 'remove_transaction'


	resources :ratings

	get 'notifications/index'

	root 'pages#show'

	get 'signup' => 'companies#new'
	get 'login' => 'session#new', as: 'login'

	post 'login' => 'session#create'
	get 'logout' => 'session#destroy'


	get 'auction/:auction_id/supplier_invite', to: 'session#invited_supplier_setup', as: 'invited_supplier_setup'
	post 'temp_login', to: 'session#temp_login', as: 'temp_login'
#
	get '/auctions/:id/set_auction_to_false' => 'auctions#set_auction_to_false', as: 'set_auction_to_false'
	get 'auctions/:auction_id/bids/:id/purchase_confirmation' => 'auctions#purchase_confirmation', as: 'auction_purchase_confirmation'


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
	get 'auctions/:auction_id/supplier_bid' => 'bids#temp_user_new_bid', as: 'temp_user_new_bid'
	post 'auctions/:auction_id/supplier_bid' => 'bids#temp_user_create_bid', as: 'temp_user_create_bid'
	patch '/add_suppliers/:id' => "auctions#invite_more_suppliers", as: "invite_more_suppliers"

	resources :password_resets

	resources :inventory_parts do
		resources :documents, shallow: true
	end

	resources :bids do
		resources :documents, shallow: true
	end

	resources :auctions do
		resources :auction_parts, except: [:index]
		resources :bids, except: [:index]
	end

	get 'auction_invites' => 'auctions#auction_invites', as: 'auction_invites'

	resources :companies, except: [:index, :show] do
		resources :ratings
		resources :inventory_parts do
			collection { post :import }
		end
	end

	resources :parts, only: [:new, :index] do
		collection { post :import }
	end

	get 'companies/confirm_email/:confirm_token', to: 'companies#confirm_email', as: 'confirm_email'

	resources :company_docs

	#errors
	match "/404", :to => "errors#not_found", :via => :all
	match "/500", :to => "errors#internal_server_error", :via => :all

	#landing page stuff
	resource :pages, only: [:show]
	get 'pricing', to: 'pages#pricing', as: 'pricing'
	get 'features', to: 'pages#features', as: 'features'
	get 'aircraft_listing', to: 'pages#aircraft_listing', as: 'aircraft_listing'
	get 'engine_listings', to:'pages#engine_listings', as: 'engine_listings'
	get 'aircraft_show/:id', to: 'pages#aircraft_show', as: 'aircraft_show'
	get 'engine_show/:id' => 'pages#engine_show', as: "engine_show"


# admin views
	get 'super_index' => 'admin#super_index', as: 'super_index'
	get 'matched_auctions' => 'admin#matched_auctions', as: 'matched_auctions'
	get 'unmatched_auctions' => 'admin#unmatched_auctions', as: 'unmatched_auctions'
	get 'all_auctions' => 'admin#all_auctions', as: 'all_auctions'

# sidekiq web UI
	mount Sidekiq::Web, at: '/sidekiq'

end
