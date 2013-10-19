require "oauth2"
require "mandrill"
require "gibbon"

module TeamStatus
  module Helpers

  	def mailchimp
  	  @gibbon ||= ::Gibbon::API.new ENV['MAILCHIMP_KEY']
  	  @gibbon.throws_exceptions = false
  	  return @gibbon
  	end

  	def mandrill
  	  @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
  	end

  	def google
  	  @google ||= ::OAuth2::Client.new(ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  	    :site => 'https://accounts.google.com',
  	    :authorize_url => "/o/oauth2/auth",
  	    :token_url => "/o/oauth2/token"
  	  })
  	end

  end

  class Context
    include Helpers
  end
end