# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :robots_tasks, dependent: :destroy
  has_many :robots, through: :robots_tasks
end
