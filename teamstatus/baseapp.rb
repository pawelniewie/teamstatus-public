require "sinatra"
require "sinatra/contrib"
require "sinatra/support"
require "compass"
require "sprockets/helpers"

require "teamstatus/helpers"

class BaseApp < Sinatra::Base

	register Sinatra::CompassSupport
	register Sinatra::Contrib
	register Sinatra::Namespace
	register Sinatra::MultiView

	helpers do
	  include Sprockets::Helpers
	  include TeamStatus::Helpers
	  include Split::Helper
	end

  configure do
    enable :logging

    set :assets, Sprockets::Environment.new
    set :assets_prefix, "/assets"
    set :digest_assets, true

    # MailChimp configuration: ADD YOUR OWN ACCOUNT INFO HERE!
    set :mailchimp_api_key, ENV['MAILCHIMP_KEY']
    set :mailchimp_list_name, ENV['MAILCHIMP_LIST']

    Split.configure do |config|
      config.allow_multiple_experiments = true
    end

    %w{javascripts stylesheets images}.each do |type|
      assets.append_path "assets/#{type}"
    end

    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
      config.debug       = true if development?
    end

    set :haml, { :format => :html5, :escape_html => true }
    set :scss, { :style => :compact, :debug_info => false }

    # Compass.add_project_configuration(File.join(settings.root, 'config', 'compass.rb'))
  end

  configure :production do
    set :raise_errors, false
    set :show_exceptions, false

    assets.js_compressor = Closure::Compiler.new
    Csso.install(assets)
    assets.css_compressor = :csso
    uid = Digest::MD5.hexdigest(File.dirname(__FILE__))[0,8]
    assets.cache = Sprockets::Cache::FileStore.new("/tmp/sinatra-#{uid}")
  end

end