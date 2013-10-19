Mongoid.load!("config/mongoid.yml")

class User
	include Mongoid::Document

	# has_many :appcasts

	field :email, type: String
	field :fullName, type: String
	field :callingName, type: String
	field :picture, type: String
	field :googleToken, type: String
	field :googleTokenExpires, type: Time
	field :male, type: Boolean

	index({ email: 1 }, { unique: true })
end
