# frozen_string_literal: true

module Types
  module Auth
    class AuthType < Types::BaseObject
      field :id, Int, null: true
      field :email, String, null: true
      field :cellphone_number, String, null: true
      field :user_type, String, null: true

      def user_type
        object.source.is_a?(Customer) ? :customer : :partner
      end
    end
  end
end
