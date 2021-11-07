$(document).on('turbolinks:load', function() {
  $('a.challenge_toggle').on('click', function(event){
    event.preventDefault();
    $('span.challenge').slideToggle();
  });
});
