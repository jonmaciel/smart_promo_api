class Auth < ApplicationRecord
  belongs_to :source, polymorphic: true
  has_secure_password
end
