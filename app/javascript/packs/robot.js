$(document).on('turbolinks:load', function() {
  // locate the robot kind select
  var kind = $('select#robot_kind');

  // ensure unchecking of boxes that are hidden
  function uncheckHiddenBoxes() {
    var checkboxes = $('.requires_mobility').find('input[type=checkbox]')
    checkboxes.each(function(){ 
      $(this).prop('checked', false)
    });
  }

  // toggle tasks requiring mobility upon kind select change
  kind.on('change', function() {
    if (this.value == 'unipedal'){
      uncheckHiddenBoxes()
      $('.requires_mobility').slideUp()
    } else {
      $('.requires_mobility').slideDown()
    }
  });

  // ensure hidden boxes upon page load if kind is unipedal
  if ($(kind).val() == 'unipedal') {
    uncheckHiddenBoxes()
    $('.requires_mobility').hide()
  }
});
