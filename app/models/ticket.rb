class Ticket < ApplicationRecord
  has_one :excavator, dependent: :destroy
end
