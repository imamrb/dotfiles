u# Create a user in postgres
sudo -u postgres createuser <name> -s

# If you would like to set a password for the user, you can do the following
sudo -u postgres psql
postgres=# \password <password>

# Switch to user
sudo -u postgress <username>

sudo -u postgres psql

# see users 
\du 

#Drop User 
DROP USER <username>;

#create databse 
rake db:create

#Generate controller
rails generate controller demo index

#Generate Model
rails generate model User 

#Generate Migrations
rails generate migration DoNothingYet


rails db:migrate

# connect to postgres
sudo -u postgres psql

# display all users =# \du
# List all database =# \l
# connect to database =# \c dbname
# query : select * from users;
#display all tables 
\dt
\d
# List all tables , indexes 
\d <table_name>

#Migration
rails db:migrate:status
rails db:migrate VERSION=0	

# Connect to PG Admin
cd pgadmin4/pgadmin4
source bin/activate    
python lib/python3.8/site-packages/pgadmin4/pgAdmin4.py

# Kill running python
ps -fA | grep python
kill <pid>

# kill localhost
lsof -wni tcp:3000
kill <pid>

# Rails new app

rails new myapp -d postgresql

# Move into the application directory
cd myapp

# If you setup MySQL or Postgres with a username/password, modify the
# config/database.yml file to contain the username/password that you specified

# Create the database
rake db:create

rails server

# See sources 
sudo nano /etc/apt/sources.list

# See key list
sudo apt-key list
# To delete - specify the last 8 characters only:
sudo apt-key del 73C62A1B

# To edit credentials
▶ EDITOR="code --wait" rails credentials:edit

# See in console 
Rails.application.credentials.secret_key_base

# Aliases 

# rc	rails console			Interact with your Rails app from the CLI
# rdb	rails dbconsole			Interact with your db from the console
# rs	rails server			Launch a web server
# rdm	rake db:migrate			Run pending db migrations
# rdms	rake db:migrate:status	Show current db migration status
# rdr	rake db:rollback		Roll back the last migration
# rr	rake routes				List all defined routes
# rrg	rake routes | grep		List and filter the defined routes

# Put these line on top of controller

ActiveSupport::Dependencies.log_activity = true
ActiveSupport::Dependencies.logger = Rails.logger


# check if an array of hashes has a key value pair 

User.find(3).todays_attendance.any? { |h| h[:check_out_time] == nil }

# Generate ERD Digram

sudo apt-get install graphviz

gem 'rails-erd'

rake erd attributes=primary_keys,foreign_keys,content indirect=true inheritance=true polymorphism=true

gem 'railroady'

rake diagram:all


# Stop the server

kill -9 $(cat tmp/pids/server.pid)

# Find All listen ports

sudo netstat -n -a -p -l -4 -6 | grep LISTEN


# Rails Bisect Command

for i in {1..10}; do bundle e rspec ./spec/controllers/users_controller_spec.rb --fail-fast --order rand --bisect=verbose; done

