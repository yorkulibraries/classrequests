# README

## About
**This project is a result of the University Academic Plan Goal:** <em>"To adopt user experience and design thinking approaches to reinvent library programs and services that ensure flexible and responsive ways of meeting our diverse community’s needs and demonstrate commitment to evidence-based assessment."</em>

**Purpose:** Ability to manage and streamline the process of teaching requests from Faculty to library, coordination with SLAS department and gather metrics on library teaching services and resources.

## Setup / Installation
___
### 1. Install



<ins>**<span style="color:green">Docker Dev Installation</span>**<ins>
1. Assumption you have docker installed for your OS. For Mac, Docker Desktop is running.
2. Clone the Repo: 
   ``` git clone git@github.com:yorkulibraries/classrequests.git OR https://github.com/yorkulibraries/classrequests.git ```
3. cd classrequests
4. cd config and rename database.yml.sample to database.yml
5. <em>If you are developer for Library Digital Systems and Initiatives, you will need master.key file. Check with the team. </em>
6. The docker files and docker-compose.yml are already in the project.
7. Run: ``` docker-compose up ```
   1. It will start downloading the images and building them
   2. There are 4 containers it will build/create.
      1. classreq_app2 that holds the applicaition code
      2. classreq_mysql_db that holds the database (shared)
      3. classreq_test2 that is used for testing
      4. chrome-server that is used for acceptance testing / system tests
8. Visit https://localhost:3000
9. If website shows up, great! install worked. Move on to Application Settings below

<ins>**<span style="color:green">Manual Dev Setup / Installation</span>**<ins>

**Details to follow, listing highlights for further documentation:**

1. Install Homebrew for mac or use yum/apt for linux: 
```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"``` 
1. Google on setting up Ruby on Rails on Mac/Ubuntu/Your OS to get step by step instructioins. E.g. https://gorails.com/setup/macos/14-sonoma
2. Once you have setup the ruby on rails, mysql, and other settings. Then, Repeat Steps 2 to 5 from docker installation.
3. Visit https://localhost:3000
4. If website shows up, great! install worked. Move on to Application Settings below. Otherwise troubleshoot.


### 2. Application Settings

Now that you have environment setup, time to setup classrequests app settings / default values.

* Course Assets are in ```/lib/assets```
* Two rake files we will be using are courses.rake and db.rake in ```/lib/tasks/```

1. Edit: db.rake with your default admin user and institutional departments/options.
2. if you are using docker for development, access the container
   1. ```docker-compose exec classreq_app2 bash```
   2. ```cd /var/app``` if not already in the directory. check with ```pwd``` or ```ls -l```
   3. **prefix commands #3 to #7 below with ```bundle exec <insert rails command>```** 
3. Database does not exist. Lets create it. Run: ```rails db:migrate``` 
4. Time to load depts, form options etc. Run: ```rails db:load_defaults```
5. Admin user to login first time (delete this user later or update password to be a stronger one). Run: ```rails db:create_production_users```
6. Add admin user role/profile. Run: ```rails db:create_production_profiles``` 
7. First time loading courses for drop down lists in the form to be populated with YorkU courses. Run: ```rails courses:init``` Course updates how-to will be in later docs. Note. This will take a while, go to step 8 for now.
8. Setup Application Settings via web interface.
   1. Visit: http://localhost:3000
   2. Login
   3. In the top menu, Admin -> App Settings -> Fill in default values, contact info etc. 
   4. Save Settings.
9. Check on course script progress. Once done validate options show up in the form. Login -> Getting Started or Request a Class -> Scroll down to Course Information. Select Academic Year, Faculty and Subject. Values are updated based on previous drop down selection. 

### Troubleshooting and Resources

1. **<ins>Error #1 </ins>**
   1. **<span style="color:red">Error:</span>** ```Sprockets::FileNotFound: couldn't find file 'trix/dist/trix' with type 'text/css'```
   2. **<span style="color:green">Solution:</span>** Node Modules folder was not built. Ensure docker-compose has volume for this or you have generated them manually with ```yarn install```. 

**<ins>Useful Docker Commands</ins>**
* ```docker ps``` or ```docker ps -a``` #list of container 
* ```docker images``` # list of images
* ```docker container prune``` # remove all stopped containers
* ```docker image prune``` # remove all unused images
* ```docker volume prune``` # remove unsed volumes
* ```docker volume prune --filter "label!=keep"``` # remove unsed volumes not labelled keep.
* ```docker rmi <imageID>``` #remove single or multiple images. Just suffice other img ids for multiple.
* Access Database container: ```docker-compose exec classreq_mysql_db bash```
* Access Application container: ```docker-compose exec classreq_app2 bash```