class PartRequirementsUploadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5 }
  end

  def perform(data, company_id, project_id, address_params)
    CsvImport.mass_rfq(data, company_id, project_id, address_params)
  end
end