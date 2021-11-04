# frozen_string_literal: true

class CreateRobots < ActiveRecord::Migration[6.0]
  def change
    create_table :robots do |t|
      t.string :name
      t.integer :kind, index: true
      t.belongs_to :user, null: false, foreign_key: true, index: true
    end
  end
end
