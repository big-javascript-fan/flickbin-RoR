CarrierWave.configure do |config|
  config.asset_host = ActionController::Base.asset_host
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required unless using use_iam_profile
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required unless using use_iam_profile
    region:                'us-west-1',                  # optional, defaults to 'us-east-1'
    endpoint:              'http://s3.amazonaws.com'
  }
  config.fog_directory  = 'flickbin'                     # required

  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
  else
    config.storage = :file
  end
end
