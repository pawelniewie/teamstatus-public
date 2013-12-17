require 'rubygems'
require "bundler"
Bundler.setup(:default)
Bundler.require

require './app'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

%w{COOKIE_SECRET COOKIE_DOMAIN COOKIE_NAME MAILCHIMP_KEY MAILCHIMP_LIST GOOGLE_ANALYTICS INTERCOM_APP_ID INTERCOM_KEY MIXPANEL_APP_ID}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

if ENV['INTERCOM_APP_ID'] and ENV['INTERCOM_KEY']
	Intercom.app_id = ENV['INTERCOM_APP_ID']
	Intercom.api_key = ENV['INTERCOM_KEY']
end

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET'], :domain => ENV['COOKIE_DOMAIN'], :key => ENV['COOKIE_NAME']

map PublicApp.assets_prefix do
  run PublicApp.assets
end

map '/' do
	run PublicApp
end
