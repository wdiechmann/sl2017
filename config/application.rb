require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SL2017
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.action_controller.asset_host = Rails.application.secrets.domain_name

    config.active_job.queue_adapter = :delayed_job
    config.active_job.queue_name_prefix = Rails.env

    # Enable serving of images, stylesheets, and javascripts from an asset server
    # MY_ASSET_HOST = "localhost:3000"
    # config.action_controller.asset_host = Proc.new { |source, request|
    #   unless source.starts_with?('//')
    #     (request ? request.protocol : 'http://') +  MY_ASSET_HOST
    #   end
    # }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = %w( da en)
    config.i18n.default_locale = :da
  end
end
