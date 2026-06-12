document.addEventListener('turbo:load', function() {
  var startTime = document.getElementById('event_start_time');
  var endTime = document.getElementById('event_end_time');
  if (!startTime || !endTime) return;

  startTime.addEventListener('change', function() {
    endTime.min = startTime.value;
  });
});
