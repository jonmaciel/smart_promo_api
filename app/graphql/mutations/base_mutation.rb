# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    protected

    def add_error(error, opt = {})
      context.add_error(GraphQL::ExecutionError.new(error, opt))
    end
  end
end
