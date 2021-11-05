# frozen_string_literal: true

class CreateRobotsTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :robots_tasks do |t|
      t.belongs_to :robot, null: false, foreign_key: true, index: true
      t.belongs_to :task, null: false, foreign_key: true, index: true
      t.integer :status, index: true

      t.timestamps
    end
  end
end
