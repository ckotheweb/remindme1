require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Remindme1
  class Application < Rails::Application
    config.time_zone = 'Dublin'
    config.active_record.default_timezone = :local
    #config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

