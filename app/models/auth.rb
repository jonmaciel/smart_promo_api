class Auth < ApplicationRecord
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  belongs_to :source, polymorphic: true, inverse_of: :auth
  has_secure_password
end
