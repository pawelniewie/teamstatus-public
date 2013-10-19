require "mongoid"

module TeamStatus
	module Database

		class User
			include Mongoid::Document

			has_many :boards

			field :email, type: String
			field :fullName, type: String
			field :callingName, type: String
			field :picture, type: String
			field :googleToken, type: String
			field :googleTokenExpires, type: Time
			field :male, type: Boolean

			index({ email: 1 }, { unique: true })
			index({ "_id" => 1, "boards.name" => 1 }, { unique: true })
		end

		class Board
		    include Mongoid::Document

				belongs_to :user
		    # embeds_many :widgets

		    field :name, type: String
		    field :publicId, type: String

		    index({ publicId: 1 }, { unique: true })
		end

	end
end