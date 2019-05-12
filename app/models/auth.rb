class Auth < ApplicationRecord
  belongs_to :source, polymorphic: true, inverse_of: :auth, optional: true, dependent: :destroy

  validates :email,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
              if: -> (record) { record.email.present? }

  validates :email,
              presence: true,
              unless: -> (record) { record.cellphone_number.present? }

  validates :cellphone_number,
              uniqueness: true,
              numericality: true,
              length: { :is => 11 },
              if: -> (record) { record.cellphone_number.present? }

  validates :cellphone_number,
              presence: true,
              unless: -> (record) { record.email.present? }

  validates :password, presence: true, length: { minimum: 4 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_secure_password

  def self.find_by_login(login)
    return find_by(email: login) if login.match(/^(\d)+$/).nil?
    find_by(cellphone_number: login)
  end
end
