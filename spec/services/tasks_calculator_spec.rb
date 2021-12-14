# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksCalculator, type: :model do
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

  before(:each) do
    5.times do |i|
      Task.create(description: 'Desc',
                  eta: "#{i + 1}0000".to_i)
    end
  end

  let(:tasks) { Task.all }

  let(:calculator) do
    described_class.new(robot)
  end

  describe '#total_duration' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(calculator.total_duration).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        robot.update(kind: 'aeronautical')
        tasks.limit(2).map { |task| robot.tasks << task }
        expect(calculator.total_duration).to eq(20_000)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map { |task| robot.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        robot.update(kind: 'unipedal')
        expect(calculator.total_duration).to eq(150_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'arachnid')
        expect(calculator.total_duration).to eq(50_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'quadrupedal')
        expect(calculator.total_duration).to eq(90_000)
      end
    end
  end

  describe '#tasks_batch_info' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(calculator.batch_info).to be_nil
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
        expect(calculator.batch_info).to eq(batch_info)
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
        expect(calculator.batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'arachnid')
        batch_info =
          [
            { duration: 50_000, tasks: %w[Desc Desc Desc Desc Desc] }
          ]
        expect(calculator.batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        robot.update(kind: 'quadrupedal')
        batch_info =
          [
            { duration: 40_000, tasks: %w[Desc Desc Desc Desc] },
            { duration: 50_000, tasks: ['Desc'] }
          ]
        expect(calculator.batch_info).to eq(batch_info)
      end
    end
  end
end
