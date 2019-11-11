class Turn < ApplicationRecord
  has_many :users through: :turn_users
  has_many :turn_users

  belongs_to :group

  belongs_to :attack
  belongs_to :defence
end
