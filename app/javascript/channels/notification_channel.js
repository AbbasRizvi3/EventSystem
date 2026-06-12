import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    if (data.count !== undefined) {
      const badge = document.getElementById("notification-count")
      if (badge) {
        badge.innerText = data.count
        badge.style.display = data.count > 0 ? "inline" : "none"
      }
    }

    if (data.type === "waitlist_position") {
      const posEl = document.getElementById("waitlist-position")
      if (posEl) posEl.innerText = "Waitlist position: " + data.position
    }
  }
});
