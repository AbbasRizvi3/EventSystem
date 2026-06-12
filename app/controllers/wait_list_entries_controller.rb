class WaitListEntriesController < ApplicationController
  before_action :authenticate_user!

    def create
    @event = Event.find(params[:event_id])
    @waitlist_entry = WaitListEntry.new(user: current_user, event: @event)
    authorize @waitlist_entry

    if @event.cancelled?
      redirect_to @event, alert: "Cannot join waitlist for a cancelled event."
    elsif @event.registrations.confirmed.count < @event.capacity
      redirect_to @event, alert: "Event still has spots available. Please register instead."
    elsif WaitListEntry.exists?(user: current_user, event: @event)
      redirect_to @event, alert: "You are already on the waitlist."
    elsif @event.registrations.exists?(user: current_user, status: "confirmed")
      redirect_to @event, alert: "You are already registered for this event."

    else
      position = @event.wait_list_entries.count + 1
      @waitlist_entry.position = position
      if @waitlist_entry.save
        NotificationJob.perform_later(current_user.id, "Added to Waitlist", "You have been added to the waitlist for #{@event.title}.", "waitlist")
        redirect_to @event, notice: "You have been added to the waitlist at position #{position}."
      else
        redirect_to @event, alert: @waitlist_entry.errors.full_messages.join(", ")
      end
    end
  end

  def destroy
    @waitlist_entry = WaitListEntry.find(params[:id])
    authorize @waitlist_entry
    @waitlist_entry.destroy
    redirect_to @waitlist_entry.event, notice: "You have left the waitlist."
  end

  def index
    @event = Event.find(params[:event_id])
    @waitlist_entries = policy_scope(@event.wait_list_entries).includes(:user).order(:position)
    authorize WaitListEntry
  end
end
