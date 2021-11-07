$(document).on('turbolinks:load', function() {
  // append items to body after duration 
  function appendItemsToLog(log, link, items, delay) {
    window.setTimeout(function() {
      // clear task log
      log.empty();
      // place list items in unordered list
      $('<ul/>', { html: items.join( '' ) })
        .appendTo(log);
      // display log
      log.fadeIn();
      // reenable link
      link.removeClass('disabled');
    }, delay);
  }

  // formulate log entry from json data
  function formulateLogEntry(data) {
    items = [];
    var name = data['name'];
    var duration = data['tasks_duration'];
    $.map(data['tasks'], function(task) {
      var description = task['description'];
      items.push('<li>' + name + ' completed ' + description + '</li>')
    });
    items.push('<li>' + name + ' took ' + duration + ' milliseconds' + '</li>')
    return items
  }

  // adapted from https://stackoverflow.com/a/22385697/2697694
  function runTimer(timer_div, count) {
    var counter;
    var initialMillis;

    timer_div.fadeIn();

    function timer() {
      if (count <= 0) {
        clearInterval(counter);
        timer_div.hide();
        return;
      }
      var current = Date.now();

      count = count - (current - initialMillis);
      initialMillis = current;
      displayCount(count);
    }

    function displayCount(count) {
      var res = count / 1000;
      var text = res.toPrecision(count.toString().length) + " secs";
      timer_div[0].innerHTML = text;
    }

    clearInterval(counter);
    initialMillis = Date.now();
    counter = setInterval(timer, 1);
  }

  function resetProgressBar(progress_bar) {
    progress_bar.css({
      width: "",
      fontSize: "",
      borderWidth: ""
    });
  }

  function animateProgressBar(progress_bar, duration) {
    resetProgressBar(progress_bar);
    progress_bar.animate({
        width: '100%'
      }, {
        queue: false,
        duration: duration
      })
  }

  function runTasks(robot_id, progress_bar, timer, log, link) {
    // hit json show endpoint to acquire robot data
    $.getJSON( '/robots/' + robot_id  + '.json', function(data) {
      duration = data['tasks_duration'];
      // decrement timer for duration
      runTimer(timer, duration);
      // animate progress_bar
      animateProgressBar(progress_bar, duration);
      // formulate log entry
      items = formulateLogEntry(data);
      // append items to log
      appendItemsToLog(log, link, items, duration);
    });
  }

  // upon click of run tasks link
  $('a.run_tasks').on('click', function(event) {
    // prevent default click event
    event.preventDefault();

    // obtain id from data attribute
    robot_id = $(this).data('robot-id');

    // define progress_bar, timer, and log elements
    var progress_bar = $("div.progress_bar[data-robot-id='" + robot_id + "']")
    var timer = $("div.timer[data-robot-id='" + robot_id + "']")
    var log = $("div.log[data-robot-id='" + robot_id + "']")
    var link = $(this);

    // disable link
    link.addClass('disabled');

    // reset log
    log.hide();

    // display task info
    runTasks(robot_id, progress_bar, timer, log, link);
  });
});
