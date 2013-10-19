require 'rubygems'
require 'bundler/setup'
require 'split/dashboard'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'teamstatus/public/app'
require 'teamstatus/console/app'

%w{COOKIE_SECRET MAILCHIMP_KEY MAILCHIMP_LIST GOOGLE_KEY GOOGLE_SECRET}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET']

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

# map '/board' do
# 	run TeamStatus::BoardApp
# end

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