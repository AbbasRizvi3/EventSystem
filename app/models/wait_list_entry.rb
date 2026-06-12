class WaitListEntry < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :event_id, message: "is already on the waitlist for this event" }
end
