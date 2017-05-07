class User < ActiveRecord::Base
  # Include default devise modules.
  devise :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :expenses, as: :resource

  scope :user_expenses, -> { where(resource_type: 'User') }
  scope :group_expenses, -> { where(resource_type: 'Group') }

end
