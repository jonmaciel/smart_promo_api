# frozen_string_literal: true

class SmartPromoApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
