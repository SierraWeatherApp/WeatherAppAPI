# API

## Install

Install ruby version 3.1.2

Install rails version 7.0.4.3

## Terminal Commands and DB

Install all the gems by running
`bundle install`

Then we bind the DB with the project

Download postgres if necessary and create a user and 2 databases
The user must be `weather_user`
and its password `defaultpw`

Then create 2 DB

1 DB called `weather_test`
1 DB called `weather_development`

Once the DB are created we run the migration to create the tables inside the DBs

`rails db:migrate`

if there is a problem try running this before each line and then the command used:
`bundle exec...`

After this it should say
"Created 2 cities"
"Created 5 questions"
"Created 18 cloth types"

If it does not run:
`rails db:seed`

That would be all, now to run the program we run:
`rails s`





