class WelcomeController < ApplicationController
  def index
  end

  def about
  end

  def team
  end

  def contact
  end

  def message
    begin
      message = {
        :subject=> "Contact for TeamStatus.TV",
        :text=>"Contact from:\nName: #{params['name']}\nEmail: #{params['email']}\n\n#{params['message']}",
        :from_name=> "TeamStatus.TV",
        :from_email=> "root@teamstatus.tv",
        :to=>[
          {:email => "pawel@teamstatus.tv", :name => "Pawel Niewiadomski"}
        ]
      }
      mandrill.messages.send message
    rescue Mandrill::Error => e
      logger.error("A mandrill error occurred: #{e.class} - #{e.message}")
      raise e
    end

    return_status_accepted
  end

  def blog
    redirect_to 'http://blog.teamstatus.tv'
  end

  def demo
    redirect_to 'http://demo.teamstatus.tv'
  end

  def features
  end

  def pricing
  end

  def privacy
  end

  def terms
  end

  def newsletter
    email = params['email']

    begin
      Intercom::User.create(:email => email, :created_at => Time.now())
      Intercom::Tag.create(:name => 'Newsletter', :emails => [email], :tag_or_untag => 'tag')

      list = mailchimp.lists.list({:filters => {:list_name => ENV['MAILCHIMP_LIST']}})
      raise "Unable to retrieve list id from MailChimp API." if list.nil? or list["status"] == "error"
      raise "List not found from MailChimp API." if list["total"].to_i != 1

      # http://apidocs.mailchimp.com/api/rtfm/listsubscribe.func.php
      # double_optin, update_existing, replace_interests, send_welcome are all true by default (change as desired)
      status = mailchimp.lists.subscribe({:id => list["data"][0]["id"], :email => {:email => email}, :double_optin => false})
      raise "Communication problem" if status.nil?
      raise "Unable to add #{email} to list from MailChimp API." if status["status"] == "error" and status["name"] != "List_AlreadySubscribed"
    rescue error
      logger.error "Error adding a subscriber #{error}"
      raise error
    end

    return_status_accepted
  end

  private

  def mailchimp
    @gibbon ||= Gibbon::API.new(ENV['MAILCHIMP_KEY'])
    @gibbon.throws_exceptions = false
    return @gibbon
  end

  def mandrill
    if (ENV['MANDRILL_KEY'])
      @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
    end
  end

end
