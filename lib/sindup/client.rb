module Sindup
  class Client < Internal::Base

    def initialize(options = {}, &block)
      @connection = Internal::Connection.new options
      initialize_collections
    end

    def authorize_url(params = {})
      @connection.authorize_url params
    end

    def current_token
      @connection.current_token
    end

    def update_token?
      @connection.update_token?
    end

    def self.received_authorization_callback(opts = {})
      opts.select { |k, v| %{mode code error}.include? k }.to_json
    end

    private

    def initialize_collections
      collection_of Folder do |connection|
        connection.define_routes(
          index:  "/folders",
          edit:   "/folders/%{folder_id}",
          create: "/folders",
          delete: "/folders/%{folder_id}"
        )
      end
      collection_of User do |conn|
        conn.define_routes(
          index:  "/users",
          find:   "/users/%{user_id}",
          self:   "/users/me",
          create: "/users",
          edit:   "/users/%{user_id}"
        )
      end
    end

  end # !Client
end # !Sindup
