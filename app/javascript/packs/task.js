$(document).on('turbolinks:load', function() {
  // append items to body after duration 
  function appendItemsToLog(log, items, delay) {
    window.setTimeout(function() {
      // clear task log
      log.empty();
      // place list items in unordered list
      $('<ul/>', { html: items.join( '' ) })
        .appendTo(log);
      // display log
      log.fadeIn();
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
  function runTimer(timer_div, count, duration) {
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

  function resetDotter(dotter) {
    dotter.css({
      width: "",
      fontSize: "",
      borderWidth: ""
    });
  }

  function animateDotter(dotter, duration) {
    resetDotter(dotter);
    dotter.animate({
        width: '100%'
      }, {
        queue: false,
        duration: duration
      })
  }

  function displayTaskInfo(robot_id, dotter, timer, log) {
    // hit json show endpoint to acquire robot data
    $.getJSON( '/robots/' + robot_id  + '.json', function(data) {
      duration = data['tasks_duration'];
      // decrement timer for duration
      runTimer(timer, duration, duration);
      // animate dotter
      animateDotter(dotter, duration);
      // formulate log entry
      items = formulateLogEntry(data);
      // append items to log
      appendItemsToLog(log, items, duration);
    });
  }

  // upon click of run tasks link
  $('a.run_tasks').on('click', function(event) {
    event.preventDefault();

    // obtain id from data attribute
    robot_id = $(this).data('robot-id');

    // define dotter, timer, and log elements
    var dotter = $("div.dotter[data-robot-id='" + robot_id + "']")
    var timer = $("div.timer[data-robot-id='" + robot_id + "']")
    var log = $("div.log[data-robot-id='" + robot_id + "']")

    // reset log
    log.hide();

    // display task info
    displayTaskInfo(robot_id, dotter, timer, log);
  });
});
