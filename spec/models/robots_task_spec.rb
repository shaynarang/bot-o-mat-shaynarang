# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RobotsTask, type: :model do
  let(:user) do
    User.create(email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password')
  end

  let(:robot) do
    Robot.create(name: 'Foo',
                 kind: 'bipedal',
                 user: user)
  end

  let(:task) do
    Task.create(description: 'Desc',
                eta: 20_000)
  end

  let(:robots_task) do
    described_class.new(robot: robot,
                        task: task)
  end

  describe 'validation' do
    it 'fails without a robot' do
      robots_task.robot = nil
      expect(robots_task).to_not be_valid
      error = /Robot must exist/
      expect { robots_task.save! }.to raise_error(error)
    end

    it 'fails without a task' do
      robots_task.task = nil
      expect(robots_task).to_not be_valid
      error = /Task must exist/
      expect { robots_task.save! }.to raise_error(error)
    end

    it 'prevents duplicate entries' do
      robot.tasks << task # task already associated
      expect(robots_task).to_not be_valid
      error = /Robot has already been taken/
      expect { robots_task.save! }.to raise_error(error)
    end
  end
end
