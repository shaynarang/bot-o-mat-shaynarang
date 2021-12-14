$(document).on('turbolinks:load', () => {
  $('a.challenge_toggle').on('click', function(event){
    event.preventDefault();
    $('span.challenge').slideToggle();
  });
});
