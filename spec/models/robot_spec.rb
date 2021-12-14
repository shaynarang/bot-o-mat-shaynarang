# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Robot, type: :model do
  let(:user) do
    User.create(email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password')
  end

  subject do
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

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'returns the number of appendages' do
    expect(subject.appendage_count).to eq(2)
  end

  it 'returns the mobility' do
    expect(subject.mobile?).to be_truthy
  end

  describe 'validation' do
    let(:task) { Task.create(description: 'Desc', eta: 20_000) }

    context 'task amount' do
      it 'validates the amount of tasks' do
        tasks.map { |task| subject.tasks << task }
        subject.tasks << task
        error = /Robot cannot have more than five tasks/
        expect { subject.save! }.to raise_error(error)
      end
    end

    context 'mobility' do
      it 'validates mobility' do
        subject.kind = 'unipedal'
        task.update(requires_mobility: true)
        subject.tasks << task
        error = /Robot must be mobile to complete this task/
        expect { subject.save! }.to raise_error(error)
      end
    end
  end

  describe 'tasks duration' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(subject.tasks_duration).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        subject.update(kind: 'aeronautical')
        tasks = Task.limit(2)
        tasks.map { |task| subject.tasks << task }
        expect(subject.tasks_duration).to eq(20_000)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map { |task| subject.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        subject.update(kind: 'unipedal')
        expect(subject.tasks_duration).to eq(150_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'arachnid')
        expect(subject.tasks_duration).to eq(50_000)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'quadrupedal')
        expect(subject.tasks_duration).to eq(90_000)
      end
    end
  end

  describe 'tasks batch info' do
    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(subject.tasks_batch_info).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        subject.update(kind: 'aeronautical')
        tasks = Task.limit(2)
        tasks.map { |task| subject.tasks << task }
        batch_info =
          [
            { duration: 20_000, tasks: %w[Desc Desc] }
          ]
        expect(subject.tasks_batch_info).to eq(batch_info)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map { |task| subject.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        subject.update(kind: 'unipedal')
        batch_info =
          [
            { duration: 10_000, tasks: ['Desc'] },
            { duration: 20_000, tasks: ['Desc'] },
            { duration: 30_000, tasks: ['Desc'] },
            { duration: 40_000, tasks: ['Desc'] },
            { duration: 50_000, tasks: ['Desc'] }
          ]
        expect(subject.tasks_batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'arachnid')
        batch_info =
          [
            { duration: 50_000, tasks: %w[Desc Desc Desc Desc Desc] }
          ]
        expect(subject.tasks_batch_info).to eq(batch_info)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'quadrupedal')
        batch_info =
          [
            { duration: 40_000, tasks: %w[Desc Desc Desc Desc] },
            { duration: 50_000, tasks: ['Desc'] }
          ]
        expect(subject.tasks_batch_info).to eq(batch_info)
      end
    end
  end
end
