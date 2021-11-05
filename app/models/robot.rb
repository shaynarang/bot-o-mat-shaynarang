# frozen_string_literal: true

class Robot < ApplicationRecord
  belongs_to :user
  has_many :robots_tasks, dependent: :destroy
  has_many :tasks, through: :robots_tasks

  enum kind: { unipedal: 0, bipedal: 1, quadrupedal: 2, arachnid: 3, radial: 4, aeronautical: 5 }
end
