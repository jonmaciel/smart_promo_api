class Partner < ApplicationRecord
  has_one :auth, as: :source, inverse_of: :source, dependent: :destroy
  has_one :wallet, as: :source, inverse_of: :source, dependent: :destroy

  validates :cnpj, length: { is: 14 }, uniqueness: true
  validates :name, :adress, :cnpj, presence: true

  accepts_nested_attributes_for :auth, :wallet
end
