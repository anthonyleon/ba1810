class InventoryDestroyerWorker
  include Sidekiq::Worker

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  def perform(user_id)
    Company.find(user_id).inventory_parts.find_each(&:destroy)
  end
end
