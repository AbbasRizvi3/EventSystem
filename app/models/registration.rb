class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, { confirmed: "confirmed", cancelled: "cancelled" }


  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :event_id, message: "has already registered for this event" }
  scope :confirmed, -> { where(status: "confirmed") }
end
