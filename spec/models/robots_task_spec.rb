# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RobotsTask, type: :model do
  let(:user) {
    User.create(email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password')
  }

  let(:robot) {
    Robot.create(name: 'Foo',
                 kind: 'bipedal',
                 user: user)
  }

  let(:task) {
    Task.create(description: 'Desc',
                eta: 20000)
  }

  subject {
    described_class.new(robot: robot,
                        task: task)
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a robot' do
    subject.robot = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a task' do
    subject.task = nil
    expect(subject).to_not be_valid
  end

  it 'prevents duplicate entries' do
    robot.tasks << task # task already associated
    expect(subject).to_not be_valid
    error = /Robot has already been taken/
    expect{ subject.save! }.to raise_error(error)
  end

  it 'validates the amount of tasks' do
    10.times { Task.create(description: 'Desc', eta: 20000) }
    tasks = Task.all
    error = /Robot cannot have more than five tasks/
    expect{ tasks.map{ |task| robot.tasks << task } }.to raise_error(error)
  end

  it 'validates mobility' do
    robot.tasks.destroy_all
    robot.kind = 'unipedal'
    task.update(requires_mobility: true)
    error = /Robot must be mobile to complete this task/
    expect{ robot.tasks << task }.to raise_error(error)
  end
end
