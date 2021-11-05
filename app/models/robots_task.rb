# frozen_string_literal: true

class RobotsTask < ApplicationRecord
  belongs_to :robot
  belongs_to :task

  validates_uniqueness_of :robot, scope: :task
end
