# frozen_string_literal: true

unless User.exists?(email: 'user@example.com')
  User.create(email: 'user@example.com',
              password: 'password')
end

tasks = [
  {
    description: 'do the dishes',
    eta: 1000,
    requires_mobility: false
  },{
    description: 'sweep the house',
    eta: 3000,
    requires_mobility: true
  },{
    description: 'do the laundry',
    eta: 10000,
    requires_mobility: false
  },{
    description: 'take out the recycling',
    eta: 4000,
    requires_mobility: true
  },{
    description: 'make a sammich',
    eta: 7000,
    requires_mobility: false
  },{
    description: 'mow the lawn',
    eta: 20000,
    requires_mobility: true
  },{
    description: 'rake the leaves',
    eta: 18000,
    requires_mobility: true
  },{
    description: 'give the dog a bath',
    eta: 14500,
    requires_mobility: false
  },{
    description: 'bake some cookies',
    eta: 8000,
    requires_mobility: false
  },{
    description: 'wash the car',
    eta: 20000,
    requires_mobility: false
  },
]

tasks.each do |task|
  Task.create(task) unless Task.exists?(task)
end
