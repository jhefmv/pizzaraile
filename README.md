# README

Pizzaraile is a simple application for managing pizzas and toppings. It runs on [Rails 7](https://rubyonrails.org/) with [Bootstrap 5](https://getbootstrap.com/).


## Requirements

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) version 3.3.4

* [Ruby on Rails](https://rubyonrails.org/)

* [PostgreSQL](https://www.postgresql.org/)

## Configurations

### Database

1. Create a new role in postgres
2. Rename the file **config/database.yml.sample** to **config/database.yml**
2. Edit **config/database.yml** and replace the values of `host`, `port` and `username` and `password` with the credentials used when creating the new db role.
```yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
development:
  <<: *default
  database: pizzaraile_development
  username: new_role_username
  password: new_role_password
  host: localhost
  port: 5432
test:
  <<: *default
  database: pizzaraile_test
  username: new_role_username
  password: new_role_password
  host: localhost
  port: 5432
```
3. Create the database by running the command: `bin/rails db:create`
4. Run the migration scripts to create the tables by running the command: `bin/rails db:migrate`

## Running locally

1. Start the Rails server by running the command: `bin/rais server`
2. Open a browser window and navigate to http://localhost:3000

## Running tests

Unit and request test are writte in [RSpec](https://rspec.info/). To run the tests, issue either one the commands below:

```
rspec
rspec --format=documentation
bin/rake spec
bundle exec rspec
```
