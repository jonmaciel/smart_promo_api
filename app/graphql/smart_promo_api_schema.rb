# frozen_string_literal: true

class SmartPromoApiSchema < GraphQL::Schema
  use GraphQL::Subscriptions::ActionCableSubscriptions, redis: Redis.new
  mutation(Types::MutationType)
  query(Types::QueryType)
  subscription(Types::SubscriptionType)
end
