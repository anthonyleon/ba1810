CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['AWS_S3_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_S3_SECRET_ACCESS_KEY'],
    :region                => ENV['S3_REGION']
  }
  config.fog_directory     =  'bidaero'


  config.cache_dir = "#{Rails.root}/tmp/uploads"

end
