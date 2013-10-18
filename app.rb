require "bundler"
Bundler.setup(:default)
Bundler.require

class App < Sinatra::Base
  register Sinatra::CompassSupport
  register Sinatra::Contrib
  register Sinatra::Namespace

  helpers Split::Helper

  configure do
    enable :logging

    set :public_dir, File.dirname(__FILE__) + '/public'
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

    Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
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

  helpers do
    include Sprockets::Helpers

    def mailchimp
      @gibbon ||= Gibbon::API.new(ENV['MAILCHIMP_KEY'])
      @gibbon.throws_exceptions = false
      return @gibbon
    end
  end

  get '/' do
    haml :index
  end

  post '/signup' do
    finished("twitter")

    email = params[:email]
    unless email.nil? || email.strip.empty?

      list = mailchimp.lists.list({:filters => {:list_name => settings.mailchimp_list_name}})
      raise "Unable to retrieve list id from MailChimp API." if list.nil? or list["status"] == "error"
      raise "List not found from MailChimp API." if list["total"].to_i != 1

      # http://apidocs.mailchimp.com/api/rtfm/listsubscribe.func.php
      # double_optin, update_existing, replace_interests, send_welcome are all true by default (change as desired)
      status = mailchimp.lists.subscribe({:id => list["data"][0]["id"], :email => {:email => email}, :double_optin => true})
      raise "Unable to add #{email} to list from MailChimp API." if status.nil? or status["status"] == "error"
    end
    "Success."
  end
end