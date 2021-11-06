json.name @robot.name
json.kind @robot.kind
json.tasks_duration @robot.tasks_duration
json.tasks @robot.tasks do |task|
  json.description task.description
  json.eta task.eta
end
