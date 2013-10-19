require 'rubygems'
require 'bundler/setup'
require 'split/dashboard'

require './app'

%w{COOKIE_SECRET MAILCHIMP_KEY MAILCHIMP_LIST GOOGLE_KEY GOOGLE_SECRET}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET']

map App.assets_prefix do
  run App.assets
end

map '/' do
	run App
end

if ENV['REDISCLOUD_URL']
	Split.redis = ENV["REDISCLOUD_URL"]
end

Split.redis.namespace = "split:teamstatus"
Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'pawel' && password == 'dupaJasiu'
end

map '/split' do
	run Split::Dashboard
end