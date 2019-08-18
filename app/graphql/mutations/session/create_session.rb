# frozen_string_literal: true

module Mutations
  module Session
    class CreateSession < Mutations::BaseMutation
      graphql_name 'CreateSession'
      null true
      description 'Create new session'

      argument :login, String, 'User login', required: true
      argument :password, String, 'User password', required: true

      field :auth_token, String, null: true
      field :auth, Types::Auth::AuthType, null: true
      field :partner, Types::Partners::PartnerType, null: true
      field :customer, Types::Customers::CustomerType, null: true

      def resolve(login:, password:)
        @login = login
        @password = password

        if auth_user.success?
          {
            auth_token: auth_token,
            auth: auth,
            user_array_key => user
          }
        else
          raise(GraphQL::ExecutionError, 'unauthorized')
        end
      end

      private

      attr_reader :login, :password

      def auth_user
        @auth_user ||= AuthenticateUser.call(login, password)
      end

      def auth_token
        auth_user.result[:token]
      end

      def auth
        auth_user.result[:auth]
      end

      def user
        @user ||= auth_user.result[:auth].source
      end

      def user_array_key
        @user_array_key ||= user.is_a?(Customer) ? :customer : :partner
      end
    end
  end
end
