# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Robot, type: :model do
  let(:user) do
    User.create(email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password')
  end

  let(:robot) do
    described_class.new(name: 'Foo',
                        kind: 'bipedal',
                        user: user)
  end

  before(:each) do
    5.times do |i|
      Task.create(description: 'Desc',
                  eta: "#{i + 1}0000".to_i)
    end
  end

  let(:tasks) { Task.all }

  describe 'validation' do
    it 'fails without a user' do
      robot.user = nil
      expect(robot).to_not be_valid
      error = 'must exist'
      expect(robot.errors.messages[:user]).to eq [error]
    end

    it 'fails without a name' do
      robot.name = nil
      expect(robot).to_not be_valid
      error = "can't be blank"
      expect(robot.errors.messages[:name]).to eq [error]
    end

    it 'fails without a kind' do
      robot.kind = nil
      expect(robot).to_not be_valid
      error = "can't be blank"
      expect(robot.errors.messages[:kind]).to eq [error]
    end
  end

  describe 'task validation' do
    context 'task amount' do
      it 'validates the amount of tasks' do
        tasks.map { |task| robot.tasks << task }
        robot.tasks << tasks.first.dup
        expect(robot).to_not be_valid
        error = 'cannot have more than five tasks'
        expect(robot.errors.messages[:base]).to eq [error]
      end
    end

    context 'mobility' do
      it 'validates mobility' do
        robot.kind = 'unipedal'
        tasks.last.update(requires_mobility: true)
        robot.tasks << tasks.last
        expect(robot).to_not be_valid
        error = 'must be mobile to complete this task'
        expect(robot.errors.messages[:base]).to eq [error]
      end
    end
  end

  describe '#appendage_count' do
    it 'returns the number of appendages' do
      expect(robot.appendage_count).to eq(2)
    end
  end

  describe '#mobile?' do
    it 'returns the mobility' do
      expect(robot.mobile?).to be_truthy
    end
  end

  describe '#tasks_duration' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(robot.tasks_duration).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        robot.update(kind: 'aeronautical')
        tasks.limit(2).map { |task| robot.tasks << task }
        expect(robot.tasks_duration).to eq(20_000)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map { |task| robot.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        robot.update(kind: 'unipedal')
        expect(robot.tasks_duration).to eq(150_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'arachnid')
        expect(robot.tasks_duration).to eq(50_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'quadrupedal')
        expect(robot.tasks_duration).to eq(90_000)
      end
    end
  end

  describe '#tasks_batch_info' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(robot.tasks_batch_info).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        robot.update(kind: 'aeronautical')
        tasks.limit(2).map { |task| robot.tasks << task }
        batch_info =
          [
            { duration: 20_000, tasks: %w[Desc Desc] }
          ]
        expect(robot.tasks_batch_info).to eq(batch_info)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map { |task| robot.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        robot.update(kind: 'unipedal')
        batch_info =
          [
            { duration: 10_000, tasks: ['Desc'] },
            { duration: 20_000, tasks: ['Desc'] },
            { duration: 30_000, tasks: ['Desc'] },
            { duration: 40_000, tasks: ['Desc'] },
            { duration: 50_000, tasks: ['Desc'] }
          ]
        expect(robot.tasks_batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'arachnid')
        batch_info =
          [
            { duration: 50_000, tasks: %w[Desc Desc Desc Desc Desc] }
          ]
        expect(robot.tasks_batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'quadrupedal')
        batch_info =
          [
            { duration: 40_000, tasks: %w[Desc Desc Desc Desc] },
            { duration: 50_000, tasks: ['Desc'] }
          ]
        expect(robot.tasks_batch_info).to eq(batch_info)
      end
    end
  end
end
