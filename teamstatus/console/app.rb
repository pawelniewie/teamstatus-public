require "teamstatus/db"
require "teamstatus/helpers"

class ConsoleApp < BaseApp
  helpers do
    def user_id
      return session[:user_id]
    end
  end

  before do
    # HTTPS redirect
    # if settings.environment == :production && request.scheme != 'https'
      # redirect "https://#{request.env['HTTP_HOST']}"
    # end
    redirect '/' if not user_id
  end

  get '/console' do
    haml :console
  end

end
