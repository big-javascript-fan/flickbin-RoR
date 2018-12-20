CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required unless using use_iam_profile
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required unless using use_iam_profile
    region:                'us-west-1'                   # optional, defaults to 'us-east-1'
  }

  if Rails.env.production?
    config.fog_directory  = 'flickbin'
  elsif Rails.env.staging?
    config.fog_directory  = 'flickbinstaging'
  end

  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
  else
    config.asset_host = ApplicationMailer.asset_host
    config.storage = :file
  end
end
