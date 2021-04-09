# Heureka
A Command-Line-Interface (CLI) to start the microservice MS-DROPS. It is the base for the user management of the microservice architecture.

## Pre-Requirements
- Install Git ([https://git-scm.com/](https://git-scm.com/))
- Configure your [GitHub account](https://docs.github.com/en/github/getting-started-with-github/set-up-git). Save a SSH public key of your systems user in your GitHub account.
- Install docker ([https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/))
- Install docker-compose ([https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/))
- The Heureka-CLI is a [GNU Bash](https://www.gnu.org/software/bash/)-Script. Thus, make sure your OS has bash installed.
- The Heureka-CLI requires `sudo` operations. Thus, make sure your user has `sudo` access rights.

## Installation
The Heureka-CLI is a script library. Thus, you just have to clone it to use it.
```
git clone https://github.com/SOTETO/heureka.git heureka-cli
cd heureka-cli
# Start the Heureka-CLI
bash ./heureka
```
Due to a [known issue](https://github.com/SOTETO/grav-dockerfile/issues/1), there are access rights problems with the GRAV documentation setup. As a workaround, you have to set `chmod -R 777 .docker-conf/base/grav`.

## Manual
Please choose the environment you want to setup:
- `dev drops` - Initiate a development environment for the MS-DROPS.
- `dev infra` - Initiate a development environment for infrastructure services and widget required to run the microservices.
- `dev new`   - Initiate a development environment for a complete new microservice.
- `prod`      - A production environment.

You can also use `exit` to quit the console.

### Development environment - Create a new microservice
Setting up the environment to develop a new microservice requires a bit of configuration effort. See a list of commands available in this environment:

#### Best practice for DEV configuration
1. Setup the required git repositories for your new MS
2. Optional: Add the repositories to the `git-setup.cfg`, if it becomes part of MS-DROPS or an infrastructure system
3. Change the database configurations in `.docker-conf/mode_dev/.env`
4. Add an nginx upstream for your local new MS in `.docker-conf/mode_dev/nginx/pool2.upstream` (see new or arise and drops as an example)
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_dev/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `DEV` environment
- `exit` - Close console
- \* - Help

#### Deployment
Follow the upcoming steps to create your development environment:
0. Start your application using all required ports except the ports used in `dev.yml` (heureka uses ports 80, 443, 9000 and 4222 by default).
0. Edit the placeholder upstream `new` in `.docker-conf/mode_dev/nginx/pool2.upstream` and add more required upstreams (the ports at the localhost used by your application).
0. Use the new / updated upstreams in `.docker-conf/mode_dev/nginx/location.pool` by introducing new pathes or editing the plaeholder path `/new`.
1. `up`
1. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
2. Create an account by using the registration view on `http://localhost`.
3. Use `admin` to grant admin rights to your newly created user.
4. Request `/docu` to initiate an admin account for your local Grav CMS instance,

After all, your microservice will be available by calling `http://localhost/new` (or the pathes that you have introduced. Using the default `dev.yml`, the REST-API of MS-DROPS will be available by calling `http://localhost/drops/<endpoint>` or `http://localhost:9000/<endpoint>` and the NATS listens to `localhost:4222`. Keep in mind that you have to configure an API user to call the REST-API of MS-DROPS or execute the OAuth handshake.

### MS-DROPS Development environment
Setting up the microservice environment requires a lot of configuration. This console supports you in doing it. The following commands are implemented: 

- `git clone` - Clone the required git repositories
- `git rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/mode_dev_ms_drops/.env` file
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm drops volumes` - Remove the drops volumes. That means the database contents.
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `drops up man` - Shows a manual explaining how to setup the DROPS backend service
- `drops admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `arise up man` - Shows a manual explaining how to setup the ARISE frontend service
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help

#### Best practice for DEV configuration
1. Setup the required git repositories for your new MS
2. Optional: Add the repositories to the `git-setup.cfg`, if it becomes part of MS-DROPS or an infrastructure system
3. Change the database configurations in `.docker-conf/mode_dev/.env`
4. Add an nginx upstream for your local new MS in `.docker-conf/mode_dev/nginx/pool2.upstream` (see new or arise and drops as an example)
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_dev/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `DEV` environment
- `exit` - Close console
- \* - Help

#### Deployment
Follow the upcoming steps to create your development environment:
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg` (default is `~/heureka/ms-drops/...` for MS-DROPS). If you change the default path, also change the path value of the `GRAV_PATH` variable in `.docker-conf/mode_dev/.env` file.
1. `git clone`
2. `docker up`
3. Follow `drops up man`
1. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
4. Follow `arise up man`
5. Create an account by using the registration view on `http://localhost`.
6. Use `drops admin` to grant admin rights to your newly created user.
7. Request `/docu` to initiate an admin account for your local Grav CMS instance, the base for the documentation.

### Infrastructure development environment
Required to clone all git repositories for the development of infrastructure services like `dispenser` or `vca-widget-base`.

- `clone` - Clone the required git repositories
- `rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/mode_infra/.env` file (starts the dispenser database on `localhost:27017`)
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help

Follow the upcoming steps to create your development environment:
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg>
1. `clone`
2. `docker up`
3. Configure the local `application.conf` in your dispenser repository to listen to `localhost:27017` (or another port, if you have changed it in your `infra.yml`)

### Production environment
If you want to setup a production environment, you have the following commands:

- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_prod/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `PROD` environment
- `exit` - Close console
- \* - Help

#### Best practice for PROD configuration
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg` (default is `~/heureka/...`). If you change the default path, also change the path value of the `GRAV_PATH` variable in `.docker-conf/mode_dev/.env` file.
1. Change the database configurations in `.docker-conf/mode_prod/.env`.
2. Change the application secrets of drops (`.docker-conf/mode_prod/drops/application.conf`) and dispenser (`.docker-conf/mode_prod/dispenser/application.conf`). Both should have a length of 64 characters.
3. Change the server name (`localhost`) in `.docker-conf/mode_prod/nginx/default.conf`.
4. Add an SSH config (on Port 443)

#### Deployment
Follow the upcoming steps to create your development environment:
1. `up`
2. Create an account by using the registration view on `http://localhost`.
3. Use `admin` to grant admin rights to your newly created user.
4. Request `/docu` to initiate an admin account for your local Grav CMS instance, the base for the documentation.

## Configuration files
There are several configuration files to make the MS-architecture more save:

### Docker compose configuration
- `base.yml`
- `dev.yml`
- `dev_ms_drops.yml`
- `prod.yml`
- `ìnfra.yml`
- `.docker-conf/mode_dev/.env`
- `.docker-conf/mode_dev_ms_drops/.env`
- `.docker-conf/mode_infra/.env`
- `.docker-conf/mode_prod/.env`

### Git configuration
The `git-setup.cfg` contains for every git repository the URL, the name and the branch that has to be selected. Additionally, you can set a local file system path for the repositories (default is `~/heureka/...`).

### Play2 configuration
The following files contain the configuration for the play2 apps:
- `.docker-conf/mode_prod/drops/application.conf`
- `.docker-conf/mode_dev/drops/application.conf`
- `.docker-conf/mode_dev_ms_drops/drops/application.conf`
- `.docker-conf/mode_prod/dispenser/application.conf`
- `.docker-conf/mode_dev/dispenser/application.conf`
- `.docker-conf/mode_dev_ms_drops/dispenser/application.conf`

### Navigation configuration
- `.docker-conf/mode_dev/navigation/GlobalNav.json`
- `.docker-conf/mode_dev/navigation/noSignIn.json`
- `.docker-conf/mode_dev_ms_drops/navigation/GlobalNav.json`
- `.docker-conf/mode_dev_ms_drops/navigation/noSignIn.json`
- `.docker-conf/mode_prod/navigation/GlobalNav.json`
- `.docker-conf/mode_prod/navigation/noSignIn.json`

### Nginx configuration
- `.docker-conf/mode_dev/nginx/default.conf`
- `.docker-conf/mode_dev/nginx/location.pool`
- `.docker-conf/mode_dev/nginx/pool2.upstream`

- `.docker-conf/mode_dev_ms_drops/nginx/default.conf`
- `.docker-conf/mode_dev_ms_drops/nginx/location.pool`
- `.docker-conf/mode_dev_ms_drops/nginx/pool2.upstream`

- `.docker-conf/mode_prod/nginx/default.conf`
- `.docker-conf/mode_prod/nginx/location.pool`
- `.docker-conf/mode_prod/nginx/pool2.upstream`
