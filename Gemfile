source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.2'

# Google Analytics
gem 'rack-google-analytics'

# Smart ENV management
gem 'figaro'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Logging to stdout by default
gem 'rails_stdout_logging'

# Mails
# Mails
gem 'gibbon'
gem 'intercom'
gem 'mandrill-api', :require => "mandrill"

# Views
gem 'haml-rails'
gem 'less-rails'
gem 'bootstrap-sass', '~> 3.1.0.0'
gem 'font-awesome-rails'
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
	# Monitoring
	gem 'newrelic_rpm'

	# Better heroku support (serving static files and logging to stdout)
	gem 'rails_12factor'
end

group :test do
	gem 'minitest'
	gem 'capybara'
	gem 'rspec-rails'
end

# Use unicorn as the app server
gem 'unicorn'