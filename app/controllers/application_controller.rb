class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  private

  def set_csrf_cookie_for_ng
  	if protect_against_forgery?
  		cookies['XSRF-TOKEN'] = {
  			value: form_authenticity_token,
  			domain: ENV['COOKIE_DOMAIN']
  		}
  	end
  end

  def verified_request?
  	super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def return_status_accepted
    render :nothing => true, :status => :accepted
  end

end
