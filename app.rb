require "./teamstatus/baseapp"

class PublicApp < BaseApp
  configure do
    set :root, File.dirname(__FILE__)
  end

  helpers do

    def mandrill
      if (ENV['MANDRILL_KEY'])
        @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
      end
    end

    def heroku
      ENV['DYNO']
    end

    def mixpanel_id
      ENV['MIXPANEL_APP_ID']
    end

    def beta
      ENV['BETA']
    end

    def mailchimp
      @gibbon ||= Gibbon::API.new(ENV['MAILCHIMP_KEY'])
      @gibbon.throws_exceptions = false
      return @gibbon
    end
  end

  get '/' do
    haml :index
  end

  get '/signup' do
    haml :betasignup
  end

  post '/signup' do
    email = params[:email]
    unless email.nil? || email.strip.empty?
      Intercom::User.create(:email => email, :created_at => Time.now())
      Intercom::Tag.create(:name => 'Newsletter', :emails => [email], :tag_or_untag => 'tag')

      list = mailchimp.lists.list({:filters => {:list_name => ENV['MAILCHIMP_LIST']}})
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