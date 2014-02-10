module MixpanelHelper
	def mixpanel_id
		return ENV['MIXPANEL_APP_ID']
	end
end