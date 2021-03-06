$(document).on('turbolinks:load', () => {
  // Locate the robot kind select.
  const kind = $('select#robot_kind');

  // Disable tasks with mobility requirements.
  function disableTasksWithMobilityRequirements() {
    const checkboxes = $('.requires_mobility').find('input[type=checkbox]');
    checkboxes.each(function(){ 
      $(this).prop('disabled', true)
      // Ensure unchecking of boxes that are disabled.
      $(this).prop('checked', false)
    });
  }

  // Enable tasks with mobility requirements.
  function enableTasksWithMobilityRequirements() {
    const checkboxes = $('.requires_mobility').find('input[type=checkbox]');
    checkboxes.each(function(){
      $(this).prop('disabled', false)
    });
  }

  // Toggle ability of tasks with mobility requirements upon kind select change.
  kind.on('change', function() {
    if (this.value == 'unipedal'){
      disableTasksWithMobilityRequirements()
    } else {
      enableTasksWithMobilityRequirements()
    }
  });

  // Ensure tasks with mobility requirements are disabled upon page load if kind is unipedal.
  if ($(kind).val() == 'unipedal') {
    disableTasksWithMobilityRequirements()
  }
});
