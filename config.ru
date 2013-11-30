require 'rubygems'
require "bundler"
Bundler.setup(:default)
Bundler.require

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'teamstatus/public/app'
require 'teamstatus/console/app'

%w{COOKIE_SECRET COOKIE_DOMAIN COOKIE_NAME GOOGLE_KEY GOOGLE_SECRET BOARDS_URL MONGOHQ_URL}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

ENV['BOARDS_URL'] = ENV['BOARDS_URL'].chomp('/')

%w{MAILCHIMP_KEY MAILCHIMP_LIST GOOGLE_ANALYTICS REDISCLOUD_URL SPLIT_PASSWORD SPLIT_USER}.each do |var|
	puts "missing env var (some features will be disabled): #{var}" unless ENV[var]
end

if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET'], :domain => ENV['COOKIE_DOMAIN'], :key => ENV['COOKIE_NAME']
use Rack::Cors, :debug => false do
  allow do
    origins ENV['BOARDS_URL']

    resource '/console/ajax/*',
        :methods => [:get, :post, :put, :delete],
        :headers => :any,
        :max_age => 600,
        :credentials => true
  end
end
use Rack::Csrf, :raise => true, :header => 'X-XSRF-TOKEN', :key => ENV['COOKIE_NAME']

Mongoid.load!("config/mongoid.yml")

map PublicApp.assets_prefix do
  run PublicApp.assets
end

map '/' do
	run PublicApp
end

map '/console' do
	run ConsoleApp
end

if ENV['REDISCLOUD_URL'] and ENV['SPLIT_USER'] and ENV['SPLIT_PASSWORD']
	require 'split/dashboard'

	Split.redis = ENV["REDISCLOUD_URL"]
	Split.redis.namespace = "split:teamstatus"
	Split::Dashboard.use Rack::Auth::Basic do |username, password|
	  username == ENV['SPLIT_USER'] && password == ENV['SPLIT_PASSWORD']
	end

	map '/split' do
		run Split::Dashboard
	end
end