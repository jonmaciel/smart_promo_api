class Ticket < ApplicationRecord
  belongs_to :promotion_type
  belongs_to :partner, inverse_of: :wallet
  belongs_to :wallet, optional: true
  belongs_to :promotion_contempled, class_name: 'Promotion', foreign_key: :promotion_contempled_id, optional: true
end
