# frozen_string_literal: true

class PublicGraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {}
    result = SmartPromoPublicApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development e
  end
end

# curl -H "Content-Type: application/json" -X POST -d '{ partner (id: 1) { id } }' http://localhost:3000/public_graphql
