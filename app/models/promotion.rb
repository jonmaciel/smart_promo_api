class Promotion < ApplicationRecord
  validates :name, presence: true
  has_many :prizes, dependent: :destroy
end
