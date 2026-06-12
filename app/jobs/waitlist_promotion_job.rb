class WaitlistPromotionJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event=Event.find(event_id)
    return if event.cancelled?
    first_waitlist_entry = event.wait_list_entries.order(:position).first
    return unless first_waitlist_entry
    registration = Registration.find_or_initialize_by(user: first_waitlist_entry.user, event: event)
    registration.update!(status: "confirmed")
    NotificationJob.perform_later(first_waitlist_entry.user.id, "You're Registered!", "You have been promoted from the waitlist and are now registered for #{event.title}.", "promotion")
    first_waitlist_entry.destroy
    event.wait_list_entries.order(:position).each_with_index do |entry, index|
      entry.update!(position: index + 1)
      NotificationJob.perform_later(entry.user.id, "Waitlist Position Updated", "Your waitlist position for #{event.title} is now #{index + 1}.", "waitlist")
      NotificationChannel.broadcast_to(entry.user, { type: "waitlist_position", position: index + 1 })
    end
  end
end
