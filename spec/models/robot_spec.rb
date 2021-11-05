# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Robot, type: :model do
  let(:user) {
    User.create(email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password')
  }

  subject {
    described_class.new(name: 'Foo',
                        kind: 'bipedal',
                        user: user)
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'returns the number of appendages' do
    expect(subject.appendages).to eq(2)
  end

  it 'returns the mobility' do
    expect(subject.mobile?).to be_truthy
  end

  describe 'task duration' do
    before(:each) {
      5.times do |i|
        Task.create(description: 'Desc',
                    eta: "#{i+1}0000".to_i)
        end
    }

    let(:tasks) { Task.all }

    context 'without tasks' do
      it 'returns nothing for robots without tasks' do
        expect(subject.tasks_duration).to be_nil
      end
    end

    context 'with two tasks' do
      it 'returns the tasks duration for robots with three appendages' do
        subject.update(kind: 'aeronautical')
        tasks = Task.limit(2)
        tasks.map{ |task| subject.tasks << task }
        expect(subject.tasks_duration).to eq(20000)
      end
    end

    context 'with five tasks' do
      before(:each) { tasks.map{ |task| subject.tasks << task } }

      it 'returns the tasks duration for robots with one appendage' do
        subject.update(kind: 'unipedal')
        expect(subject.tasks_duration).to eq(150000)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'arachnid')
        expect(subject.tasks_duration).to eq(50000)
      end

      it 'returns the tasks duration for five or more appendages' do
        subject.update(kind: 'quadrupedal')
        expect(subject.tasks_duration).to eq(90000)
      end
    end
  end
end
