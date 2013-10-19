require "teamstatus/db"
require "teamstatus/helpers"
require "teamstatus/baseapp"

class PublicApp < BaseApp
  get '/' do
    haml :index
  end

  get "/auth/google" do
    session[:user_id] = nil
    session[:state] = Digest::MD5.hexdigest(rand().to_s)

    redirect google.auth_code.authorize_url(:redirect_uri => url('/auth/google/callback'),
      :scope => 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email', :access_type => "online", :state => session[:state]), 303
  end

  get '/auth/google/callback' do
    halt 403 unless session[:state] == params[:state]

    access_token = google.auth_code.get_token(params[:code], :redirect_uri => url('/auth/google/callback'))
    profile = access_token.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json').parsed.with_indifferent_access
    logger.info("Profile is #{profile.to_json}")

    user = TeamStatus::Db::User.where(email: profile[:email]).first
    if not user
      logger.info("User was not found " + profile[:email])
      user = TeamStatus::Db::User.create!(email: profile[:email], fullName: profile[:name], callingName: profile[:given_name],
        picture: profile[:picture], male: profile[:gender] == "male")

      begin
        message = {
          :subject=> "New User for TeamStatus.TV",
          :text=>"You have a new user #{user.email}",
          :from_name=> "TeamStatus.TV",
          :from_email=> "root@teamstatus.tv",
          :to=>[
            {:email => "pawelniewiadomski@me.com", :name => "Pawel Niewiadomski"},
            {:email => "jacek.jaroczynski@gmail.com", :name => "Jacek Jaroczynski"}
          ]
        }
        mandrill.messages.send message
      rescue Mandrill::Error => e
        logger.error("A mandrill error occurred: #{e.class} - #{e.message}")
      end
    end

    session[:user_id] = user._id.to_s
    redirect '/console'
  end

  post '/signup' do
    finished("twitter")

    email = params[:email]
    unless email.nil? || email.strip.empty?

      list = mailchimp.lists.list({:filters => {:list_name => settings.mailchimp_list_name}})
      raise "Unable to retrieve list id from MailChimp API." if list.nil? or list["status"] == "error"
      raise "List not found from MailChimp API." if list["total"].to_i != 1

      # http://apidocs.mailchimp.com/api/rtfm/listsubscribe.func.php
      # double_optin, update_existing, replace_interests, send_welcome are all true by default (change as desired)
      status = mailchimp.lists.subscribe({:id => list["data"][0]["id"], :email => {:email => email}, :double_optin => true})
      raise "Unable to add #{email} to list from MailChimp API." if status.nil? or status["status"] == "error"
    end
    "Success."
  end
end