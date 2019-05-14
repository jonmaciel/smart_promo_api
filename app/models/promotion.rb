class Promotion < ApplicationRecord
  belongs_to :promotion_type
  belongs_to :partner, dependent: :destroy
end
