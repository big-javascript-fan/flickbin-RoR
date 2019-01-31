if Rails.env.production? || Rails.env.staging?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], reconnect_attempts: 1, network_timeout: 60  }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], reconnect_attempts: 1, network_timeout: 60  }
  end
end

