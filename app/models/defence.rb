class Defence < ApplicationRecord
  belongs_to :turn
  belongs_to :user
end
