require "json"
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

    def boards
      @boards ||= user.boards
    end

    def board
      @board ||= TeamStatus::Db::Board.find_by(:publicId => params[:board_id]) || halt(404)
      halt(401) if @board.user_id != user._id
      return @board
    end

    def parsed_body
      request.body.rewind
      ::JSON.parse request.body.read
    end
  end

  before do
    # HTTPS redirect
    # if settings.environment == :production && request.scheme != 'https'
      # redirect "https://#{request.env['HTTP_HOST']}"
    # end
    response.set_cookie("XSRF-TOKEN", :value => Rack::Csrf.token(env))
    redirect '/' if not user_id
    redirect to('/jira') if not user.servers.exists? and request.path_info != "/jira" and not request.path_info.start_with? "/ajax/"
  end

  get '/' do
    redirect boards.first.edit_url
  end

  get '/jira' do
    haml :jira
  end

  get '/boards' do
    if not boards.exists?
      board = TeamStatus::Db::Board.new()
      board.name = "TeamBoard"
      user.boards.push(board)
    end
    haml :boards
  end

  get '/boards/:board_id/add-widget' do
    haml :"add-widget", :locals => {:board => board}
  end

  get '/partials/:partial_id' do
    haml :"partials/#{params[:partial_id]}", {:layout => false}
  end

  get "/ajax/jiraServer" do
    jiras = user.servers.where(product: 'jira')
    if jiras.count > 0
      return jiras[0].to_json
    else
      return nil
    end
  end

  post "/ajax/jiraServer" do
    server = parsed_body

    jiras = user.servers.where(product: 'jira')
    if jiras.count == 0
      server[:product] = 'jira'
      jira = TeamStatus::Db::Server.new(server)
      user.servers.push(jira)
      jira.to_json
    else
      jira = jiras.first
      jira.address = server["address"]
      jira.username = server["username"]
      jira.password = server["password"]
      jira.save()
      jira.to_json
    end
  end
end
