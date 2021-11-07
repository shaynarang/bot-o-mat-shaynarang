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

  def appendages
    case kind
    when 'unipedal'
      1
    when 'bipedal'
      2
    when 'quadrupedal'
      4
    when 'arachnid'
      8
    when 'radial'
      6
    when 'aeronautical'
      3
    end
  end

  def mobile?
    unipedal? ? false : true
  end

  # calculate the total duration of tasks assigned to a robot
  def tasks_duration
    return if tasks.empty?

    # a robot with five or more appendages can complete all tasks simultaneously
    if appendages >= 5
      # retrieve the eta of the most lengthy task
      tasks.pluck(:eta).max
    # a robot with one appendage must work through each task sequentially
    elsif appendages == 1
      # retrieve the sum of the etas
      tasks.pluck(:eta).sum
    # a robot with between one and five appendages can work in batches
    else
      # obtain the etas for all assigned tasks
      etas = tasks.pluck(:eta).sort
      # instantiate collection
      maximums = []
      # if a robot has more appendages than tasks, set the batch count to the task size
      batch_count = appendages > tasks.size ? tasks.size : appendages
      # iterate over the etas and push the maximum of each batch to the collection
      etas.each_slice(batch_count) do |batch|
        maximums << batch.max
      end
      # retrieve the sum of the collection
      maximums.sum
    end
  end

  # the method above returns a single duration combining the etas of all tasks
  # this method is granular and returns hashes containing task batches and durations
  def tasks_batch_info
    return if tasks.empty?

    # instantiate batches
    batches = []
    # a robot with five or more appendages can complete all tasks simultaneously
    if appendages >= 5
      # retrieve the eta of the most lengthy task and add all tasks to batches
      batches << {
        duration: tasks.pluck(:eta).max,
        tasks: tasks.pluck(:description)
      }
    # a robot with one appendage must work through each task sequentially
    elsif appendages == 1
      # iterate over each task and add the eta and task to batches
      tasks.each do |task|
        batches << {
          duration: task.eta,
          tasks: [task.description]
        }
      end
    # a robot with between one and five appendages can work in batches
    else
      # if a robot has more appendages than tasks, set the batch count to the task size
      batch_count = appendages > tasks.size ? tasks.size : appendages
      # iterate over multiple tasks
      tasks.order(:eta).each_slice(batch_count) do |task_batch|
        # add most lengthy eta of the batch and all tasks to batches
        batches << {
          duration: task_batch.pluck(:eta).max,
          tasks: task_batch.pluck(:description)
        }
      end
    end
    # return batches
    batches
  end

  private

  def task_amount
    error = 'cannot have more than five tasks'
    errors.add(:robot, error) if tasks&.size > 5
  end

  def mobility
    return if tasks.empty?

    error = 'must be mobile to complete this task'
    errors.add(:robot, error) if !mobile? && tasks.map(&:requires_mobility).include?(true)
  end

  def remove_mobile_tasks
    tasks.where(requires_mobility: true).destroy_all
  end
end
