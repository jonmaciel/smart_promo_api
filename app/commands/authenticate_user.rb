class AuthenticateUser
  prepend SimpleCommand

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    auth = auth_user
    { token: ::JsonWebToken.encode(user_id: auth.id), auth: auth } if auth
  end

  private

  attr_accessor :login, :password

  def auth_user
    auth = Auth.find_by_login(login)
    return auth if auth&.authenticate(password)
    errors.add :user_authentication, 'invalid credentials'

    nil
  end
end
