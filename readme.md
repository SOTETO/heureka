# Heureka
A Command-Line-Interface (CLI) to start the microservice MS-DROPS. It is the base for the user management of the microservice architecture.

## Pre-Requirements
- Have a GitHub Account configured
- Git installed
- BASH
- Docker installed (and docker-compose?)
- Sudo access

## Manual
Please choose the environment you want to setup:
- `dev drops` - Initiate a development environment for the MS-DROPS.
- `dev infra` - Initiate a development environment for infrastructure services and widget required to run the microservices.
- `prod` - A production environment.

You can also use `exit` to quit the console.

### MS-DROPS Development environment
Setting up the microservice environment requires a lot of configuration. This console supports you in doing it. The following commands are implemented: 

- `git clone` - Clone the required git repositories
- `git rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/docker-compose/.env.dev` file
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm drops volumes` - Remove the drops volumes. That means the database contents.
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `drops up man` - Shows a manual explaining how to setup the DROPS backend service
- `drops admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `arise up man` - Shows a manual explaining how to setup the ARISE frontend service
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help

Follow the upcoming steps to create your development environment:
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg` (default is `~/heureka/ms-drops/...` for MS-DROPS)
1. `git clone`
2. `docker up`
3. Follow `drops up man`
4. Follow `arise up man`
5. Create an account by using the registration view on `http://localhost`.
6. Use `drops admin` to grant admin rights to your newly created user.

### Infrastructure development environment
Required to clone all git repositories for the development of infrastructure services like `dispenser` or `vca-widget-base`.

- `clone` - Clone the required git repositories
- `rm` - Remove the git repositories
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help

Follow the upcoming steps to create your development environment:
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg>
1. `clone`

### Production environment
If you want to setup a production environment, you have the following commands:

- `up` - Start the `docker-compose up` considering the `.docker-conf/docker-compose/.env.prod` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `PROD` environment
- `exit` - Close console
- \* - Help

Follow the upcoming steps to create your development environment:
1. `up`
2. Create an account by using the registration view on `http://localhost`.
3. Use `admin` to grant admin rights to your newly created user.

## Configuration files
There are several configuration files to make the MS-architecture more save:

### Best practice for DEV configuration
1. Setup the required git repositories for your new MS
2. Optional: Add the repositories to the `git-setup.cfg`, if it becomes part of MS-DROPS or an infrastructure system
3. Change the database configurations in `.docker-conf/docker-compose/.env.dev`
4. Add an nginx upstream for your local new MS in `.docker-conf/routes/dev-nginx/pool2.upstream` (see arise and drops as an example)
5. Add new locations to the nginx `.docker-conf/routes/dev-nginx/location.pool` file (using the new upstreams).

### Best practice for PROD configuration
1. Change the database configurations in `.docker-conf/docker-compose/.env.prod`
2. Change the application secrets of drops (`.docker-conf/prod-drops/application.conf`) and dispenser (`.docker-conf/prod-dispenser/application.conf`)
3. Change the server name (`localhost`) in `.docker-conf/routes/prod-nginx/default.conf`
4. Add an SSH config (on Port 443)

### Docker compose configuration
- `base.yml`
- `dev.yml`
- `prod.yml`
- `.docker-conf/docker-compose/.env.dev`
- `.docker-conf/docker-compose/.env.prod`

### Git configuration
The `git-setup.cfg` contains for every git repository the URL, the name and the branch that has to be selected. Additionally, you can set a local file system path for the repositories (default is `~/heureka/...`).

### Play2 configuration
The following files contain the configuration for the play2 apps:
- `.docker-conf/prod-drops/application.conf`
- `.docker-conf/dev-dispenser/application.conf`
- `.docker-conf/prod-dispenser/application.conf`

### Navigation configuration
- `.docker-conf/dev-navigation/GlobalNav.json`
- `.docker-conf/dev-navigation/noSignIn.json`
- `.docker-conf/prod-navigation/GlobalNav.json`
- `.docker-conf/prod-navigation/noSignIn.json`

### Nginx configuration
- `.docker-conf/routes/dev-nginx/default.conf`
- `.docker-conf/routes/dev-nginx/location.pool`
- `.docker-conf/routes/dev-nginx/pool2.upstream`

- `.docker-conf/routes/prod-nginx/default.conf`
- `.docker-conf/routes/prod-nginx/location.pool`
- `.docker-conf/routes/prod-nginx/pool2.upstream`
