require "mongoid"
require "uri"

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
      field :created_at, type: Time, default: -> { Time.now }

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

      index({ :user_id => 1, :address => 1 }, { unique: true })
    end

    class Board
        include Mongoid::Document
        store_in collection: "boards"

        belongs_to :user
        embeds_many :widgetsettings, store_as: "settings"

        before_create :generate_publicId

        field :name, type: String
        field :publicId, type: String

        index({ :user_id => 1, :name => 1 }, { unique: true })
        index({ publicId: 1 }, { unique: true })

        def generate_publicId
          self.publicId = rand(36**10).to_s(36)
        end

        def public_url
          url = URI(ENV['BOARDS_URL'])
          url.path = "/" + self.publicId
          url.to_s
        end

        def edit_url
          url = URI(ENV['BOARDS_URL'])
          url.path = "/" + self._id + "/edit"
          url.to_s
        end
    end

    class Widgetsetting
      include Mongoid::Document
      embedded_in :board
    end
  end
end