$(document).on('turbolinks:load', () => {
  function appendEntriesToLog(log, entries, delay) {
    // Consider delay (duration) prior to append.
    window.setTimeout(() => {
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
    const unit = duration > 0 ? ' seconds' : ' second';

    items = [];
    $.map(tasks, task => {
      items.push(`<li>${name} completed ${task}</li>`)
    });
    items.push(`<li>${name} took ${duration}${unit}</li>`)
    return items
  }

  // A timer that increments in seconds.
  function runTimer(timer, total_duration, link) {
    timer.show();

    // Convert duration to seconds.
    total_duration = total_duration / 1000

    let count = 0;
    const counter = setInterval(() => {
      ++count;
      $(timer).html(count);
      // When the timer has met the total duration.
      if (count >= total_duration) {
        // Stop.
        clearInterval(counter);
        // Display the total duration.
        const unit = total_duration > 1 ? ' seconds' : ' second';
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
      duration
    })
  }

  // Obtain data and run tasks in batches.
  function runTasks(robot_id, progress_bar, timer, log, link) {
    // Hit show endpoint to acquire robot data.
    $.getJSON( `/robots/${robot_id}.json`, data => {
      const name = data['name'];
      const batches = data['tasks_batch_info'];
      const total_duration = data['tasks_duration'];
      let accumulated_duration = 0;

      // Iterate over batches of tasks.
      $.map(batches, batch => {
        const batch_duration = batch['duration'];
        const tasks = batch['tasks'];

        // Formulate log entries for current batch.
        const log_entries = formulateLogEntries(name, batch_duration, tasks);

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

    const robot_id = $(this).data('robot-id');

    const progress_bar = $(`div.progress_bar[data-robot-id='${robot_id}']`);
    const timer = $(`div.timer[data-robot-id='${robot_id}']`);
    const log = $(`div.log[data-robot-id='${robot_id}']`);
    const link = $(this);

    // Disable run tasks link.
    link.addClass('disabled');

    log.empty();
    log.hide();

    timer.hide();

    // Run timer, progress bar, and append to log.
    runTasks(robot_id, progress_bar, timer, log, link);
  });
});
