require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Public
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

  # Enabled Rails's static asset server
  config.serve_static_assets = true

	# config.assets.paths << Rails.root.join('vendor', 'assets', 'javascripts', 'plugins', 'flexslider', 'fonts')
	# config.assets.precompile += %w(*.ttf *.eot *.svg *.woff)
	# config.assets.precompile << %r(fonts/flexslider-icon\.(?:eot|svg|ttf|woff)$)
	config.assets.precompile << 'plugins/html5shiv/dist/html5shiv.js'
	config.assets.precompile << 'plugins/respond/respond.min.js'
	config.assets.precompile << 'plugins/retina/js/retina-1.1.0.min.js'

	initializer :after_append_asset_paths,
				:group => :all,
				:after => :append_assets_path do
	  # serving fonts right from flexslider/fonts
	  config.assets.paths.unshift Rails.root.join("vendor", "assets", "javascripts", "plugins", "flexslider").to_s
	end
  end
end
