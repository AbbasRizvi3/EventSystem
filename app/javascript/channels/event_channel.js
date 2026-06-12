import consumer from "channels/consumer"

const eventCard = document.querySelector("[data-event-id]")
const eventId = eventCard ? eventCard.dataset.eventId : null

if (eventId)
  consumer.subscriptions.create({channel:"EventChannel", event_id:eventId}, {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    if (data.seats_left !== undefined) {
      const seatsEl = document.getElementById("seats-available")
      if (seatsEl) seatsEl.innerText = data.seats_left + " / " + data.capacity + " spots available"
    }

    if (data.type === "cancelled") {
      const statusEl = document.getElementById("event-status")
      if (statusEl) {
        statusEl.innerText = "Cancelled"
        statusEl.className = "badge bg-danger fs-6"
      }
      const actionsEl = document.getElementById("event-actions")
      if (actionsEl) actionsEl.innerHTML = "<span class='text-muted'>This event has been cancelled.</span>"
    }
  }
});
