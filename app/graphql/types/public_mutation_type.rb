# frozen_string_literal: true

module Types
  class PublicMutationType < Types::BaseObject
    field :create_customer, mutation: Mutations::Customers::CreateCustomer

    field :create_partner, mutation: Mutations::Partners::CreatePartner

    field :create_session, mutation: Mutations::Session::CreateSession

    field :create_sms_verification_code, mutation: Mutations::AuthNotification::CreateSmsVerificationCode
    field :validate_sms_verification_code, mutation: Mutations::AuthNotification::ValidateSmsVerificationCode
  end
end
