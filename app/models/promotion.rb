class Promotion < ApplicationRecord
  belongs_to :partner, dependent: :destroy
end
