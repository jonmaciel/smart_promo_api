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

      def resolve(login:, password:)
        command = AuthenticateUser.call(login, password)

        if command.success?
          { auth_token: command.result[:token] }
        else
          raise(GraphQL::ExecutionError, 'unauthorized')
        end
      end
    end
  end
end
