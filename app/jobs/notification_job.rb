class NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, title, body, notification_type)
    user=User.find(user_id)
    user.notifications.create!(
      title: title,
      body: body,
      notification_type: notification_type
    )
    NotificationMailer.notify(user, title, body).deliver_now
    NotificationChannel.broadcast_to(user, { count: user.notifications.count })
  end
end
