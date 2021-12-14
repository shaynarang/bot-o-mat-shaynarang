# frozen_string_literal: true

class Robot < ApplicationRecord
  belongs_to :user
  has_many :robots_tasks, dependent: :destroy
  has_many :tasks, through: :robots_tasks

  enum kind: { unipedal: 0, bipedal: 1, quadrupedal: 2, arachnid: 3, radial: 4, aeronautical: 5 }

  accepts_nested_attributes_for :tasks, allow_destroy: true

  before_validation :remove_mobile_tasks, unless: -> { mobile? }

  validates_presence_of :name, :kind
  validate :task_amount_within_limit
  validate :mobility_requirement

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

  # Obtain total duration of tasks from service object.
  def tasks_duration
    TasksCalculator.new(self).total_duration
  end

  # Obtain array of hashes with task duration and descriptions from service object.
  def tasks_batch_info
    TasksCalculator.new(self).batch_info
  end

  private

  def task_amount_within_limit
    return if tasks.blank? || tasks.size <= 5

    errors.add(:base, 'cannot have more than five tasks')
  end

  def mobility_requirement
    return if tasks.blank? || mobile? || !tasks.map(&:requires_mobility).include?(true)

    errors.add(:base, 'must be mobile to complete this task')
  end

  def remove_mobile_tasks
    tasks.where(requires_mobility: true).destroy_all
  end
end
