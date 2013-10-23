require "mongoid"

module TeamStatus
  module Db

    class User
      include Mongoid::Document
      store_in collection: "users"

      has_many :boards
      has_many :servers

      field :email, type: String
      field :fullName, type: String
      field :callingName, type: String
      field :picture, type: String
      field :googleToken, type: String
      field :googleTokenExpires, type: Time
      field :male, type: Boolean

      index({ email: 1 }, { unique: true })
    end

    class Server
      include Mongoid::Document
      store_in collection: "servers"

      belongs_to :user

      field :address, type: String
      field :username, type: String
      field :password, type: String
      field :product, type: String, default: "jira"

      index({ :user_id => 1, :address => 1}, { unique: true })
    end

    class Board
        include Mongoid::Document
        store_in collection: "boards"

        belongs_to :user
        # embeds_many :widgets

        before_create :generate_publicId

        field :name, type: String
        field :publicId, type: String

        index({ :user_id => 1, :name => 1 }, { unique: true })
        index({ publicId: 1 }, { unique: true })

        def generate_publicId
          self.publicId = rand(36**10).to_s(36)
        end
    end

  end
end