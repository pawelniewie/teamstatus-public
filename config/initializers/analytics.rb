if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	Public::Application.config.middleware.use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

