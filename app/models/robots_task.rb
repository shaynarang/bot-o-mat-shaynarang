# frozen_string_literal: true

class RobotsTask < ApplicationRecord
  belongs_to :robot
  belongs_to :task

  validates_uniqueness_of :robot, scope: :task
  validate :task_amount
  validate :mobility

  private

  def task_amount
    error = 'cannot have more than five tasks'
    errors.add(:robot, error) if robot&.tasks&.count == 5
  end

  def mobility
    error = 'must be mobile to complete this task'
    errors.add(:robot, error) if !robot&.mobile? && task&.requires_mobility
  end
end
