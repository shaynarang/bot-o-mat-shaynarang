class TasksCalculator
  def initialize(robot)
    @robot = robot
    @tasks = robot.tasks
  end

  # Count of tasks to iterate over for robots with between one and five appendages.
  # If a robot has more appendages than tasks, the batch count is the tasks count.
  def batch_count
    @robot.appendage_count > @tasks.size ? @tasks.size : @robot.appendage_count
  end

  # Array of task durations for robots with between one and five appendages.
  def batch_durations(etas)
    maximums = []
    etas.sort.each_slice(batch_count) do |batch|
      maximums << batch.max
    end
    maximums
  end

  # Total duration of tasks assigned to a robot.
  # A robot with five or more appendages can complete all tasks simultaneously.
  # A robot with one appendage must work through each task sequentially.
  # A robot with between one and five appendages must work in batches.
  def total_duration
    return if @tasks.empty?

    etas = @tasks.pluck(:eta)
    case @robot.appendage_count
    when 5 then etas.max
    when 1 then etas.sum
    else batch_durations(etas).sum
    end
  end

  # Array of hashes containing task batches and durations.
  def batch_info
    return if @tasks.empty?

    batches = []
    if @robot.appendage_count >= 5
      batches << { duration: @tasks.pluck(:eta).max, tasks: @tasks.pluck(:description) }
    elsif @robot.appendage_count == 1
      @tasks.each do |task|
        batches << { duration: task.eta, tasks: [task.description] }
      end
    else
      @tasks.order(:eta).each_slice(batch_count) do |task_batch|
        batches << { duration: task_batch.pluck(:eta).max, tasks: task_batch.pluck(:description) }
      end
    end
    batches
  end
end
