## About
**This project is a result of the University Academic Plan Goal:** *"To adopt user experience and design thinking approaches to reinvent library programs and services that ensure flexible and responsive ways of meeting our diverse community’s needs and demonstrate commitment to evidence-based assessment."*

**Purpose:** Ability to manage and streamline the process of teaching requests from Faculty to library, coordination with SLAS department and gather metrics on library teaching services and resources.


# Start developing

```
git clone https://github.com/yorkulibraries/classrequests.git
cd classrequests
docker compose up --build
```

There are 3 containers created: **web**, **db** and **mailcatcher**

# Access the front end web app

By default, the application will listen on port 3009 and runs with RAILS_ENV=development.

To access the application in Chrome browser, you will need to add the ModHeader extension to your Chrome browser.

Header: PYORK_USER
Value: admin (or manager or whatever user you want to mimic)

For convenience, you can import the ModHeader profile from the included ModHeader_admin.json. 

Now you can login as if you have been authenticated by PY.

http://localhost:3009/users/ppy_login


# Access mailcatcher web app

http://localhost:3089/

# What if I want to use a different port?

If you wish to use a different port, you can set the PORT environment or change PORT in .env file.

```
PORT=4005 docker compose up --build
```

# Run tests

Start the containers if you haven't started them yet.

```
docker compose up --build
```

Run all the tests

```
docker compose exec web rt 
```

Run system tests

```
docker compose exec web rts
```

Run a specific test
```
docker compose exec web rt TEST=test/controllers/users_controller_test.rb
```

# Access chrome-server

You can access the chrome-server to see the system tests while they are running. The password is: **secret**

http://localhost:7909

# Access the containers

DB container
```
docker compose exec db bash
```

Webapp container
```
docker compose exec web bash
```

# Load the courses
```
docker compose exec web bash
rails courses:init
```

