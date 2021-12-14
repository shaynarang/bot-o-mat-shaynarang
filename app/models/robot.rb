# frozen_string_literal: true

class Robot < ApplicationRecord
  belongs_to :user
  has_many :robots_tasks, dependent: :destroy
  has_many :tasks, through: :robots_tasks

  enum kind: { unipedal: 0, bipedal: 1, quadrupedal: 2, arachnid: 3, radial: 4, aeronautical: 5 }

  accepts_nested_attributes_for :tasks, allow_destroy: true

  before_validation :remove_mobile_tasks, unless: -> { mobile? }

  validates_presence_of :name, :kind
  validate :task_amount
  validate :mobility

  # Count of appendages based on the kind of robot.
  def appendage_count
    {
      unipedal: 1,
      bipedal: 2,
      quadrupedal: 4,
      arachnid: 8,
      radial: 6,
      aeronautical: 3
    }[kind.to_sym]
  end

  # Boolean depicting only robots with multiple appendages can be mobile.
  def mobile?
    unipedal? ? false : true
  end

  # Count of tasks to iterate over for robots with between one and five appendages.
  # If a robot has more appendages than tasks, the batch count is the tasks count.
  def tasks_batch_count
    appendage_count > tasks.size ? tasks.size : appendage_count
  end

  # Array of task durations for robots with between one and five appendages.
  def task_batch_durations(etas)
    maximums = []
    etas.sort.each_slice(tasks_batch_count) do |batch|
      maximums << batch.max
    end
    maximums
  end

  # Total duration of tasks assigned to a robot.
  # A robot with five or more appendages can complete all tasks simultaneously.
  # A robot with one appendage must work through each task sequentially.
  # A robot with between one and five appendages must work in batches.
  def tasks_duration
    return if tasks.empty?

    etas = tasks.pluck(:eta)
    case appendage_count
    when 5 then etas.max
    when 1 then etas.sum
    else task_batch_durations(etas).sum
    end
  end

  # Array of hashes containing task batches and durations.
  def tasks_batch_info
    return if tasks.empty?

    batches = []
    if appendage_count >= 5
      batches << { duration: tasks.pluck(:eta).max, tasks: tasks.pluck(:description) }
    elsif appendage_count == 1
      tasks.each do |task|
        batches << { duration: task.eta, tasks: [task.description] }
      end
    else
      tasks.order(:eta).each_slice(tasks_batch_count) do |task_batch|
        batches << { duration: task_batch.pluck(:eta).max, tasks: task_batch.pluck(:description) }
      end
    end
    batches
  end

  private

  def task_amount
    return if tasks.blank? || tasks.size <= 5

    errors.add(:base, 'cannot have more than five tasks')
  end

  def mobility
    return if tasks.blank? || mobile? || !tasks.map(&:requires_mobility).include?(true)

    errors.add(:base, 'must be mobile to complete this task')
  end

  def remove_mobile_tasks
    tasks.where(requires_mobility: true).destroy_all
  end
end
