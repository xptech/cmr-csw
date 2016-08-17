require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Csw
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.relative_url_root = '/csw'
    config.assets.prefix = '/assets'

    def self.load_version
      version_file = "#{config.root}/version.txt"
      if File.exist?(version_file)
        return IO.read(version_file)
      elsif File.exist?('.git/config') && `which git`.size > 0
        version = `git rev-parse --abbrev-ref HEAD`
        return version
      end
      '(unknown)'
    end

    config.version = load_version
    # additional config parameters for ALL environments here
    config.cmr_search_endpoint = 'https://cmr.earthdata.nasa.gov/search'
    config.client_id = 'cmr_csw'
    config.cwic_tag = 'org.ceos.wgiss.cwic.granules.prod'
    config.cwic_descriptive_keyword = 'CWIC > CEOS WGISS Integrated Catalog'
    config.geoss_data_core_tag = 'org.geo.geoss_data-core'
    config.geoss_data_core_descriptive_keyword = 'This is a GEOSS Data-CORE collection with full and open unrestricted access at no more than the cost of reproduction and distribution'

    config.concept_id = 'C14758250-LPDAAC_ECS'
  end
end
