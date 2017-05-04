class Group < ApplicationRecord
  has_many :users, through: :group_users
end
