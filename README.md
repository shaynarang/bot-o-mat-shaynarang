# Bot-o-mat

## The Application
This application is the result of the Bot-o-mat challenge from Red Ventures. It allows users to create and assign tasks to robots. Robots with multiple appendages can work through multiple tasks simultaneously. Robots with one appendage (unipedal) must work through each task sequentially. Tasks that require mobility are unavailable to unipedal robots. After one or more robots have been created, users can 'Run Tasks', simultaneously if desired. The graphical interface provides a timer and a progress bar to indicate the actual amount of time it takes the robots to complete all of their tasks. Tasks and durations are added to the log as they are completed.

## Features
- User authentication
- An interface to create, edit, and destroy a robot
- An interface to assign tasks to a robot
- Client and server side validation based on the assumptions listed below
- An interface to view robot task count and duration
- A tasks timer
- A progress bar animation
- A tasks log that populates as tasks are completed in real time

## Technologies Used
- Ruby on Rails
- Postgres
- Rspec
- Devise
- JBuilder
- jQuery
- Bootstrap

## Assumptions
- Some tasks require mobility.
- The unipedal robot is not mobile so it cannot complete some tasks.
- A radial robot is mobile.
- An aeronautical robot is mobile.
- Each task requires at least one appendage to complete.
- The difference in appendage amount must have an implication on ability.
- A robot with more than one appendage can complete multiple tasks simultaneously.
- A radial robot has an unspecified number of appendages. Since it is included in this assignment, it must have some utility. As such, it most have at least one appendage. Since it is not bipedal, it must have at least three appendages in order to move. Since quadrupedal and arachnid are already types, it must not have four or eight appendages. Assuming an even number of appendages is needed for balance, six appendages is my best guess.
- An aeronautical robot has an unspecified number of appendages. Since it is included in this assignment, it must have some utility. As such, it most have at least one appendage. Robots with one, two, four, six, and eight appendages are already classified. This leaves three, five, seven, or nine plus appendages. A higher number of appendages would weight a flight-capable robot down. As such, three appendages is my best guess.
- Assuming no obstructions, all robots abide by the same eta for a single task.
- A robot can execute no more than five tasks at a time.
- A robot performing multiple tasks simultaneously must complete the longest task of the batch in order to proceed to the next batch.

## Deployment
The application has been deployed to https://quiet-taiga-20534.herokuapp.com/. You can sign up using an example email address and create robots/assign tasks from there. If you would like to set it up on your machine, the instructions are below.

## Files of Interest
- app/models/robot.rb contains the task duration logic
- app/javascript/packs/robot.js contains script that disables task selection based on mobility requirements
- app/javascript/packs/task.js contains script that runs the timer, progress bar, and appends to the task log
- app/views/robots contains the view files constituting a majority of the interface
- app/spec/models/ contains spec files for the business logic of robots and the robots_task join

## Set Up
- Clone the repository
- Navigate to the directory

## Language and Framework Versions

ruby 2.7.4p191

The preferred method of installing ruby is with rbenv [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv).
Follow the installation instructions on the project's Github.com README. You should be prompted to install the correct
version of ruby when you're in the root of the project, but it would be advisable to go ahead and install the version
of ruby necessary.

```
rbenv install 2.7.4p191
```

bundler 2.1.4

The first gem you're going to need is bundler, which is used for managing packages used in the project. In order to
install bundler, run:

```
gem install bundler
```

Follow this up by using bundler to install dependencies:

```
bundle install
```

## Database Creation

```
rake db:create
```

## Database Initialization

```
rake db:migrate db:seed
```

## Testing

```
rspec
```

## Author
- Akshay Narang <https://github.com/shaynarang>
