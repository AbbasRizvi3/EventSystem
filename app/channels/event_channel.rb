class EventChannel < ApplicationCable::Channel
  def subscribed
    event = Event.find_by(id: params[:event_id])
    event ? stream_for(event) : reject
  end

  def unsubscribed
  end
end
