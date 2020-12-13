require_relative 'boot'

require 'csv' # Require for exporting to CSV
require 'rails/all'
require 'bigdecimal'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OspreyBank
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # This allows having folder subdirectories in the images folder, ex: app/assets/images/home_page, without making changes to the images path
    # Source: https://stackoverflow.com/questions/21502608/rails-4-asset-pipeline-image-subdirectories
    Dir.glob("#{Rails.root}/app/assets/images/**/").each do |path|
      config.assets.paths << path
    end

  end
end
