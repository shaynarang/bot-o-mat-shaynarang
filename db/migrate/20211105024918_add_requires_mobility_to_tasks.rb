# frozen_string_literal: true

class AddRequiresMobilityToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :requires_mobility, :boolean
  end
end
