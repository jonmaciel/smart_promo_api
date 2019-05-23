# frozen_string_literal: true

class Customer < ApplicationRecord
  has_one :auth, as: :source, inverse_of: :source, dependent: :destroy
  has_one :wallet, as: :source, inverse_of: :source, dependent: :destroy

  accepts_nested_attributes_for :auth, :wallet

  validates :cpf, length: { is: 11 }, uniqueness: true
  validates :name, :cpf, presence: true
end
