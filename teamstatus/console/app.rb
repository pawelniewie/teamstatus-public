require "rack/csrf"
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
    response.set_cookie("XSRF-TOKEN", :value => Rack::Csrf.token(env))
    redirect '/' if not user_id
    redirect to('/jira') if not user.boards.exists? and request.path_info != "/jira"
  end

  get '/' do
    haml :console
  end

  get '/jira' do
    haml :jira
  end

  get '/boards' do
    haml :boards
  end

  post "/ajax/jiraServer" do
    logger.info(params)
    true.to_json
  end

end
