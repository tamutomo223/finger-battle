class Defence < ApplicationRecord
  belongs_to :turn,optional: true
  belongs_to :user,optional: true
end
