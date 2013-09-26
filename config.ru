require 'rubygems'
require 'bundler/setup'

# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
#require 'rack/google-analytics'
#use Rack::GoogleAnalytics, :tracker => "YOUR GOOGLE ANALYTICS ACCOUNT ID HERE"

%w{COOKIE_SECRET MAILCHIMP_KEY MAILCHIMP_LIST}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET']

require './app'
run Sinatra::Application