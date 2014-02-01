class WelcomeController < ApplicationController
  def index
  end

  def about
  end

  def team
  end

  def contact
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

    return_status_accepted
  end

  private

  def mailchimp
    @gibbon ||= Gibbon::API.new(ENV['MAILCHIMP_KEY'])
    @gibbon.throws_exceptions = false
    return @gibbon
  end
end
