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
      field :user, Types::UserUnion, null: true

      def resolve(login:, password:)
        @login = login
        @password = password

        if auth_user.success?
          { auth_token: auth_token, user: user }
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

      def user
        auth_user.result[:auth].source
      end
    end
  end
end
