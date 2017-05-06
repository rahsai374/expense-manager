class Group < ApplicationRecord
  has_many :users, through: :group_users
  has_many :expenses, as: :resource 
end
