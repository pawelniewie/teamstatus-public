require "oauth2"
require "mandrill"
require "gibbon"

module TeamStatus
  module Helpers

  	def mandrill
      if (ENV['MANDRILL_KEY'])
        @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
      end
  	end

  	def google
  	  @google ||= ::OAuth2::Client.new(ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  	    :site => 'https://accounts.google.com',
  	    :authorize_url => "/o/oauth2/auth",
  	    :token_url => "/o/oauth2/token"
  	  })
  	end

    def heroku
      ENV['DYNO']
    end

  end

  class Context
    include Helpers
  end
end