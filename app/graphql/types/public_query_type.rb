# frozen_string_literal: true

module Types
  class PublicQueryType < Types::BaseObject
    field :customer_check, Boolean, null: true do
      argument :field, Types::PublicCustomerCheckFieldsEnum, required: true
      argument :value, String, required: true
    end

    field :tickets, [Types::Tickets::TicketType], null: true do
      argument :promotion_id, Int, required: true
      argument :cellphone_number, String, required: true
    end

    field :promotion_by_partner, Types::Promotions::PromotionType, null: true do
      argument :partner_id, Int, required: true
    end

    def customer_check(field:, value:)
      case field
      when 'cellphone_number'
        ::Auth.where(cellphone_number: value)
      when 'email'
        ::Auth.where(email: value)
      when 'cpf'
        Customer.where(cpf: value)
      end.any?
    end

    def tickets(promotion_id:, cellphone_number:)
      customer = ::Auth.find_by(cellphone_number: cellphone_number)&.source

      return [] unless customer

      customer.wallet.tickets.where(contempled_promotion_id: promotion_id)
    end

    def promotion_by_partner(partner_id:)
      Promotion.where(partner_id: partner_id).first
    end
  end
end
