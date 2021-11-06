$(document).on('turbolinks:load', function() {
  // locate the robot kind select
  var kind = $('select#robot_kind');

  // disable tasks with mobility requirements
  function disableTasksWithMobilityRequirements() {
    var checkboxes = $('.requires_mobility').find('input[type=checkbox]')
    checkboxes.each(function(){ 
      $(this).prop('disabled', true)
      // ensure unchecking of boxes that are disabled
      $(this).prop('checked', false)
    });
  }

  // enable tasks with mobility requirements
  function enableTasksWithMobilityRequirements() {
    var checkboxes = $('.requires_mobility').find('input[type=checkbox]')
    checkboxes.each(function(){
      $(this).prop('disabled', false)
    });
  }

  // toggle ability of tasks with mobility requirements upon kind select change
  kind.on('change', function() {
    if (this.value == 'unipedal'){
      disableTasksWithMobilityRequirements()
    } else {
      enableTasksWithMobilityRequirements()
    }
  });

  // ensure tasks with mobility requirements are disabled upon page load if kind is unipedal
  if ($(kind).val() == 'unipedal') {
    disableTasksWithMobilityRequirements()
  }
});
