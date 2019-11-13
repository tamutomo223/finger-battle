class Turn < ApplicationRecord
  has_many :turn_users
  has_many :users, through: :turn_users


  belongs_to :group,optional: true

  belongs_to :attack,optional: true
  belongs_to :defence,optional: true
end
