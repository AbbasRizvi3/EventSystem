function applyAdminRule() {
  var adminCheckbox = document.querySelector('.role-checkbox[data-role="admin"]');
  if (!adminCheckbox) return;

  var checkboxes = document.querySelectorAll('.role-checkbox');
  var adminChecked = adminCheckbox.checked;

  checkboxes.forEach(function(cb) {
    if (cb.dataset.role !== 'admin') {
      cb.disabled = adminChecked;
      if (adminChecked) cb.checked = false;
    }
  });

  var submitBtn = document.getElementById('update-roles-btn');
  if (submitBtn) {
    var anyChecked = Array.from(checkboxes).some(function(cb) { return cb.checked; });
    submitBtn.disabled = !anyChecked;
  }
}

document.addEventListener('turbo:load', function() {
  if (!document.querySelector('.role-checkbox')) return;
  applyAdminRule();
  document.querySelectorAll('.role-checkbox').forEach(function(checkbox) {
    checkbox.addEventListener('change', applyAdminRule);
  });
});
