class Expense < ApplicationRecord
  include AASM

  belongs_to :resource, polymorphic: true
  belongs_to :user

  aasm column: 'status' do
    state :unpaid, initial: true
    state :paid

    event :pay do
      transitions :from => :unpaid, :to => :paid
    end
  end
end
