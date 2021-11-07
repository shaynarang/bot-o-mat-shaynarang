# BOT-O-MAT
Use any language to complete this challenge. The implementation is up to you: it can be a command-line application or have a graphical interface.

Your application should collect a name and robot type from the types we list below. For each, it should create a Robot of the type the user chooses, e.g. Larry, Bipedal. 

Given the list of tasks below, your application should then assign the Robot a set of five tasks, all of which complete after a duration that we show in milliseconds. 



- Collect a name and robot type from user.
- Instantiate a Robot of the type provided by the user with the name provided by the user
  - for example: Bipedal, Larry
- Set up methods on Robot to complete tasks from the provided list

## Robot
Robot completes tasks and removes them from the list when they are done (i.e. enough time has passed since starting the task).

## Tasks
Tasks have a description and an estimated time to complete.

```
[
  {
    description: 'do the dishes',
    eta: 1000,
  },{
    description: 'sweep the house',
    eta: 3000,
  },{
    description: 'do the laundry',
    eta: 10000,
  },{
    description: 'take out the recycling',
    eta: 4000,
  },{
    description: 'make a sammich',
    eta: 7000,
  },{
    description: 'mow the lawn',
    eta: 20000,
  },{
    description: 'rake the leaves',
    eta: 18000,
  },{
    description: 'give the dog a bath',
    eta: 14500,
  },{
    description: 'bake some cookies',
    eta: 8000,
  },{
    description: 'wash the car',
    eta: 20000,
  },
]
```

## Types
```
{ 
  UNIPEDAL: 'Unipedal',
  BIPEDAL: 'Bipedal',
  QUADRUPEDAL: 'Quadrupedal',
  ARACHNID: 'Arachnid',
  RADIAL: 'Radial',
  AERONAUTICAL: 'Aeronautical'
}
```

## Features to add once the core functionality is complete
Be creative and have fun! Use this list or create your own features.
- Allow users to create multiple robots at one time
- Create a leaderboard for tasks completed by each Robot
- Create tasks specific for each robot type, this could work in conjunction with the leaderboard. For e.g. robots that are assigned tasks that their type can’t perform won’t get “credit” for finishing the task.
- Add persistance for tasks, bots and leaderboard stats

## Privacy Guidelines
Due to the creative nature of this project, please do not post the prompt or your solution publicly. Feel free to privately fork it to your personal GitHub or download it for future reference, as this workspace is cleared every few months.

## Authors
- Scott Hoffman <https://github.com/scottshane>
- Olivia Osby <https://github.com/oosby>



## The Application
This application allows users to create and assign tasks to robots. Robots with multiple appendages can work through multiple tasks simultaneously. Robots with one appendage (unipedal) must work through each task sequentially. Tasks that require mobility are unavailable to unipedal robots. After one or more robots have been created, users can 'Run Tasks', simultaneously if desired. The graphical interface provides a countdown timer and a progress bar to indicate the actual amount of time it takes the robots to complete all of their tasks.

## Features
- User authentication
- An interface to create, edit, and destroy a robot
- An interface to assign tasks to a robot
- Client and server side validation based on the assumptions listed below
- An interface to view robot task count and duration
- A tasks countdown timer
- A progress bar animation

## Technologies Used
- Ruby on Rails
- Postgres
- Rspec
- Devise
- JBuilder
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
