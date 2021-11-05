# frozen_string_literal: true

class Robot < ApplicationRecord
  belongs_to :user
  has_many :robots_tasks, dependent: :destroy
  has_many :tasks, through: :robots_tasks

  enum kind: { unipedal: 0, bipedal: 1, quadrupedal: 2, arachnid: 3, radial: 4, aeronautical: 5 }

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

  def tasks_duration
    return if tasks.empty?

    if appendages >= 5
      tasks.pluck(:eta).max
    elsif appendages == 1
      tasks.pluck(:eta).sum
    else
      etas = tasks.pluck(:eta).sort
      maximums = []
      batch_count = appendages > tasks.count ? tasks.count : appendages
      etas.each_cons(batch_count) do |batch|
        maximums << batch.max
      end
      maximums.sum
    end
  end
end
