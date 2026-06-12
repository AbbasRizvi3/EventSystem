class Notification < ApplicationRecord
  belongs_to :user

  validates :body, presence: true
  validates :title, presence: true
  validates :notification_type, presence: true
end
