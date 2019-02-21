require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Birdy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.active_job.queue_adapter = :sidekiq
    config.i18n.default_locale = :en
    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths += %W(
      #{config.root}/lib/
    )

    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
