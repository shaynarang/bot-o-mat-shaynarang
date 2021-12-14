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
end
