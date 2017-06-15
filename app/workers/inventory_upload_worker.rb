class InventoryUploadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  def perform(data, company_id)
    CsvImport.import_inventory(data, Company.find(company_id))
  end
end