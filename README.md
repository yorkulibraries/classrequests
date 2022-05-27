# README

## About
**This project is a result of the University Academic Plan Goal:** <em>"To adopt user experience and design thinking approaches to reinvent library programs and services that ensure flexible and responsive ways of meeting our diverse community’s needs and demonstrate commitment to evidence-based assessment."</em>

**Purpose:** Ability to manage and streamline the process of teaching requests from Faculty to library, coordination with SLAS department and gather metrics on library teaching services and resources.

## Setup / Installation

Details to follow, listing highlights for further documentation:

1. Assumed you have your ruby and rails environment setup already.
2. clone repo to your server
3. create the mysql / sqllite database
4. create config/database.yml (see sample below)
5. run the db:rake tasks for default data
  * If this is fresh install or testing, create default admin account.
  * Run sample data task to create sample course data for testing app
6. Login and create your application settings + save
7. Decide on auth systems to use. Out of box comes with Devise db.
8. If setup on local dev
  1. run the above steps / tasks as needed
  2. cd to app directory, run `rails s`
  3. go to `http://localhost:3000` in the browser
