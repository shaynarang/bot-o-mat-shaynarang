$(document).on('turbolinks:load', function() {
  $('a.requirement_toggle').on('click', function(event){
    event.preventDefault();
    $('span.requirements').slideToggle();
  });
});
