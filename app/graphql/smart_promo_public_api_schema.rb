# frozen_string_literal: true

class SmartPromoPublicApiSchema < GraphQL::Schema
  mutation(Types::PublicMutationType)
  query(Types::PublicQueryType)
end
