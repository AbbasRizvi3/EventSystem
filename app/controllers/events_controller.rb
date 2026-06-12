class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show edit update destroy cancel ]

  def index
    @events = policy_scope(Event).page(params[:page]).per(10)
  end

  def show
    authorize @event
  end

  def new
    @event = Event.new
    authorize @event
  end

  def edit
    authorize @event
  end

  def create
    @event=current_user.events.build(event_params)
    authorize @event

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to events_url, notice: "Event was successfully destroyed."
  end

  def cancel
  authorize @event
  @event.update(status: "cancelled")
  @event.attendees.each do |user|
    NotificationJob.perform_later(user.id, "Event Cancelled", "#{@event.title} has been cancelled.", "cancellation")
  end
  @event.waitlisted_users.each do |user|
    NotificationJob.perform_later(user.id, "Event Cancelled", "#{@event.title} has been cancelled.", "cancellation")
  end
  EventChannel.broadcast_to(@event, { type: "cancelled" })
  redirect_to @event, notice: "Event has been cancelled."
  end

 def my_events
  unless current_user.roles.exists?(name: "attendee") || current_user.roles.exists?(name: "admin")
    redirect_to events_path, alert: "Not authorized."
    return
  end
  @events = current_user.registered_events.page(params[:page]).per(10)
end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :location, :start_time, :end_time, :capacity, :status)
    end
end
