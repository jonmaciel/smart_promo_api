class Wallet < ApplicationRecord
  belongs_to :source, polymorphic: true
end
