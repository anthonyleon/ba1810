class InventoryUploadWorker
  include Sidekiq::Worker

  def perform(file_path, company_id)
    CsvImport.csv_import(file_path, Company.find(company_id))
  end
end