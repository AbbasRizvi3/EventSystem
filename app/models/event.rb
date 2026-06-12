class Event < ApplicationRecord
  belongs_to :user

  enum :status, { active: "active", cancelled: "cancelled" }
  validate :end_time_after_start_time


  validates :title, presence: true, uniqueness: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  has_many :registrations, dependent: :destroy
  has_many :attendees, through: :registrations, source: :user
  has_many :wait_list_entries, dependent: :destroy
  has_many :waitlisted_users, through: :wait_list_entries, source: :user

  private
  def end_time_after_start_time
  return if end_time.blank? || start_time.blank?
  errors.add(:end_time, "must be after start time") if end_time <= start_time
  end
end
