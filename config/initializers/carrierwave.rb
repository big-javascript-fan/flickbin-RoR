CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   :provider               => 'AWS',
  #   :aws_access_key_id      => Rails.application.secrets.aws_access_key_id,
  #   :aws_secret_access_key  => Rails.application.secrets.aws_secret_access_key,
  #   :region                 => 'eu-central-1'
  # }

  config.storage = :file
  config.asset_host = ActionController::Base.asset_host

  # config.fog_directory = 'birdy'
  #config.fog_host       = 'https://assets.example.com'           # optional, defaults to nil
  #config.fog_public     = false                                  # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
