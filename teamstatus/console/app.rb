require "teamstatus/db"
require "teamstatus/helpers"

class ConsoleApp < BaseApp
  configure do
    set :root, File.dirname(__FILE__)
  end

  helpers do
    def user_id
      return session[:user_id]
    end

    def user
      @user ||= TeamStatus::Db::User.find(user_id) || halt(404)
    end
  end

  before do
    # HTTPS redirect
    # if settings.environment == :production && request.scheme != 'https'
      # redirect "https://#{request.env['HTTP_HOST']}"
    # end
    redirect '/' if not user_id
  end

  get '/' do
    haml :console
  end

  get '/jira' do
    haml :jira
  end

end
