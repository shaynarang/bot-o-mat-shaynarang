$(document).on('turbolinks:load', function() {
  // append entries to log after duration
  function appendEntriesToLog(log, entries, delay) {
    // consider delay (duration) prior to append
    window.setTimeout(function() {
      // place list entries in unordered list
      $('<ul/>', { html: entries.join( '' ) })
        .appendTo(log);
      // display log
      log.fadeIn();
    }, delay);
  }

  // formulate log entry from json data
  function formulateLogEntries(name, duration, tasks) {
    // convert duration to seconds
    duration = duration / 1000
    // account for singular second
    var unit = duration > 0 ? ' seconds' : ' second'
    // instantiate collection
    items = [];
    // iterate over tasks
    $.map(tasks, function(task) {
      // formulate li with name and task and push to items
      items.push('<li>' + name + ' completed ' + task + '</li>')
    });
    // formulate li with name and duration and unit and push to items
    items.push('<li>' + name + ' took ' + duration + unit + '</li>')
    // return collection
    return items
  }

  // a timer that increments in seconds
  function runTimer(timer, total_duration, link) {
    // display timer
    timer.show();
    // convert total duration to seconds
    total_duration = total_duration / 1000
    // instantiate count
    var count = 0;
    // place counter function in variable
    var counter = setInterval(function() {
      // increment count
      ++count;
      // set html to current count
      $(timer).html(count);
      // when the timer has met the total duration
      if (count >= total_duration) {
        // stop
        clearInterval(counter);
        // display the total duration
        var unit = total_duration > 1 ? ' seconds' : ' second'
        $(timer).html(total_duration + unit);
        // reenable link
        link.removeClass('disabled');
      }
    }, 1000);
  }

  // reset progress bar back to default settings
  function resetProgressBar(progress_bar) {
    progress_bar.css({
      width: '',
      fontSize: '',
      borderWidth: ''
    });
  }

  // animate the width of the progress bar
  function animateProgressBar(progress_bar, duration) {
    // reset progress bar to default settings
    resetProgressBar(progress_bar);
    // run animation
    progress_bar.animate({
        width: '100%'
      }, {
        queue: false,
        duration: duration
      })
  }

  // obtain data and run tasks in batches
  function runTasks(robot_id, progress_bar, timer, log, link) {
    // hit json show endpoint to acquire robot data
    $.getJSON( '/robots/' + robot_id  + '.json', function(data) {
      // define name, batches, total duration, and accumulated duration
      var name = data['name']
      var batches = data['tasks_batch_info']
      var total_duration = data['tasks_duration']
      var accumulated_duration = 0;

      // iterate over batches of tasks
      $.map(batches, function(batch){
        // define duration and tasks of current batch
        var batch_duration = batch['duration']
        var tasks = batch['tasks'];

        // formulate log entries for current batch
        var log_entries = formulateLogEntries(name, batch_duration, tasks);

        // add current batch duration to accumulated duration
        accumulated_duration += batch_duration;

        // run tumer, animate progress bar, and append entries to log
        runTimer(timer, total_duration, link);
        animateProgressBar(progress_bar, total_duration)
        appendEntriesToLog(log, log_entries, accumulated_duration);
      });
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

    // disable run tasks link
    link.addClass('disabled');

    // reset log
    log.empty();
    log.hide();

    // hide timer in case it is already visible
    timer.hide();

    // run timer, progress bar, and append to log
    runTasks(robot_id, progress_bar, timer, log, link);
  });
});
