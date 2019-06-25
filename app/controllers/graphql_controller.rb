# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :authenticate_request

  attr_reader :current_user

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user
    }
    result = SmartPromoApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development e
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end

# curl -H "Content-Type: application/json" -X POST -d '{"email":"joaomaciel.n@mail.com","password":"123123123"}' http://localhost:3000/authenticate
# curl -H "Content-Type: application/json" -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1ODgyOTcxNDR9.UoWmJUr4XS1eaNFEqHh6jnsf5PskcAhVwvxOFffuUxs" -X POST -d '{ partner (id: 1) { id } }' http://localhost:3000/graphql
