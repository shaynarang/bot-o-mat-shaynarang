# frozen_string_literal: true

class RobotsTask < ApplicationRecord
  belongs_to :robot
  belongs_to :task

  validates_uniqueness_of :robot, scope: :task
  validate :task_amount

  private

  def task_amount
    errors.add(:robot, 'cannot have more than five tasks') if robot.tasks.count == 5
  end
end
