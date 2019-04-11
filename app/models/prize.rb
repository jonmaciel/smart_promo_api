class Prize < ApplicationRecord
  belongs_to :promotion
  validates :name, presence: true, uniqueness: true
end
