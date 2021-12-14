$(document).on('turbolinks:load', function() {
  function appendEntriesToLog(log, entries, delay) {
    // Consider delay (duration) prior to append.
    window.setTimeout(function() {
      $('<ul/>', { html: entries.join( '' ) })
        .appendTo(log);
      log.fadeIn();
    }, delay);
  }

  // Formulate log entry from json data.
  function formulateLogEntries(name, duration, tasks) {
    // Convert duration to seconds.
    duration = duration / 1000
    // Account for singular second.
    var unit = duration > 0 ? ' seconds' : ' second'

    items = [];
    $.map(tasks, function(task) {
      items.push('<li>' + name + ' completed ' + task + '</li>')
    });
    items.push('<li>' + name + ' took ' + duration + unit + '</li>')
    return items
  }

  // A timer that increments in seconds.
  function runTimer(timer, total_duration, link) {
    timer.show();

    // Convert duration to seconds.
    total_duration = total_duration / 1000

    var count = 0;
    var counter = setInterval(function() {
      ++count;
      $(timer).html(count);
      // When the timer has met the total duration.
      if (count >= total_duration) {
        // Stop.
        clearInterval(counter);
        // Display the total duration.
        var unit = total_duration > 1 ? ' seconds' : ' second'
        $(timer).html(total_duration + unit);
        // Reenable run tasks link.
        link.removeClass('disabled');
      }
    }, 1000);
  }

  // Reset progress bar to default settings.
  function resetProgressBar(progress_bar) {
    progress_bar.css({
      width: '',
      fontSize: '',
      borderWidth: ''
    });
  }

  // Animate the width of the progress bar.
  function animateProgressBar(progress_bar, duration) {
    resetProgressBar(progress_bar);
    progress_bar.animate({
      width: '100%'
    }, {
      queue: false,
      duration: duration
    })
  }

  // Obtain data and run tasks in batches.
  function runTasks(robot_id, progress_bar, timer, log, link) {
    // Hit show endpoint to acquire robot data.
    $.getJSON( '/robots/' + robot_id  + '.json', function(data) {
      var name = data['name']
      var batches = data['tasks_batch_info']
      var total_duration = data['tasks_duration']
      var accumulated_duration = 0;

      // Iterate over batches of tasks.
      $.map(batches, function(batch){
        var batch_duration = batch['duration']
        var tasks = batch['tasks'];

        // Formulate log entries for current batch.
        var log_entries = formulateLogEntries(name, batch_duration, tasks);

        accumulated_duration += batch_duration;

        runTimer(timer, total_duration, link);
        animateProgressBar(progress_bar, total_duration)
        appendEntriesToLog(log, log_entries, accumulated_duration);
      });
    });
  }

  // Upon click of run tasks link.
  $('a.run_tasks').on('click', function(event) {
    event.preventDefault();

    var robot_id = $(this).data('robot-id');

    var progress_bar = $("div.progress_bar[data-robot-id='" + robot_id + "']")
    var timer = $("div.timer[data-robot-id='" + robot_id + "']")
    var log = $("div.log[data-robot-id='" + robot_id + "']")
    var link = $(this);

    // Disable run tasks link.
    link.addClass('disabled');

    log.empty();
    log.hide();

    timer.hide();

    // Run timer, progress bar, and append to log.
    runTasks(robot_id, progress_bar, timer, log, link);
  });
});
