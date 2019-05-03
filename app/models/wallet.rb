class Wallet < ApplicationRecord
  belongs_to :source, polymorphic: true, inverse_of: :wallet
end
