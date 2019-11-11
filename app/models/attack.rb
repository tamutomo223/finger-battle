class Attack < ApplicationRecord
  belongs_to :turn
  belongs_to :user
end
