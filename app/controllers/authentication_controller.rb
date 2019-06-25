# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result[:token], user: command.result[:auth] }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
