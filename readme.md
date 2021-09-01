# Heureka
A Command-Line-Interface (CLI) to start the microservice MS-DROPS. It is the base for the user management of the microservice architecture.

## Pre-Requirements
- Install Git ([https://git-scm.com/](https://git-scm.com/))
- *Optional: Configure your [GitHub account](https://docs.github.com/en/github/getting-started-with-github/set-up-git). Save a SSH public key of your systems user in your GitHub account.*
- Install docker ([https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/) - Please follow dockers instructions to install all required features!)
- Install docker-compose ([https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/))
- The Heureka-CLI is a [GNU Bash](https://www.gnu.org/software/bash/)-Script. Thus, make sure your OS has bash installed.
- The Heureka-CLI requires `sudo` operations. Thus, make sure your user has `sudo` access rights.

*Hardware:* You should have at least 4 GB working memory for using the `dev drops` environment.
*Versions:* Please use always the newest versions of `git` (latest release: 2.32.0 at the moment of writing), `docker` (latest release: 20.10.8 at the moment of writing) and `docker-compose` (latest release: 1.29.2 at the moment of writing)! Keep in mind that official repositories for your OS are maybe older.

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
- `prod`      - A production environment.
- `dev new`   - Initiate a development environment for a complete new microservice.
- `dev drops` - *Additional:* Initiate a development environment for the MS-DROPS.
- `dev infra` - *Additional:* Initiate a development environment for infrastructure services and widget required to run the microservices.

You can also use `exit` to quit the console.

_Configuration:_ As a best practice, the configuration should always be edited _before_ the console will be used. Otherwise, the state of the console could become invalid.

### Development environment - Create a new microservice
Setting up the environment to develop a new microservice requires a bit of configuration effort.

#### Deployment
Follow the upcoming steps to create your development environment:

1. `bash ./heureka`
2. `dev new` to enter the development environment of the CLI
3. Start your application using all required ports except the ports used in `dev.yml` (heureka uses ports 80, 443, 9000 and 4222 by default).
4. Edit the placeholder upstream `new` in `.docker-conf/mode_dev/nginx/pool2.upstream` and add more required upstreams (the ports at the localhost used by your application).
5. Use the new / updated upstreams in `.docker-conf/mode_dev/nginx/location.pool` by introducing new pathes or editing the plaeholder path `/new`.
6. `up`
7. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
8. Create an account by using the registration view on `http://localhost`.
9. Use `admin` to grant admin rights to your newly created user.
10. Request `/docu` to initiate an admin account for your local Grav CMS instance.
11. Initiate the navigation by calling `http://localhost/dispenser/navigation/init`. In case of a whitescreen, the call has been successfully.

After all, your microservice will be available by calling `http://localhost/new` (or the pathes that you have introduced. Using the default `dev.yml`, the REST-API of MS-DROPS will be available by calling `http://localhost/drops/<endpoint>` or `http://localhost:9000/<endpoint>` and the NATS listens to `localhost:4222`. Keep in mind that you have to configure an API user to call the REST-API of MS-DROPS or execute the OAuth handshake.

#### Best practice for DEV configuration
1. Setup the required git repositories for your new MS.
2. Optional: Add the repositories to the `git-setup.cfg`.
3. Change the database configurations for MS-DROPS (`DROPS_DB_*`) and other existing microservices in `.docker-conf/mode_dev/.env`.
4. Add an nginx upstream for your local new MS in `.docker-conf/mode_dev/nginx/pool2.upstream` (see new or arise and drops as an example).
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

#### Hints for the deployment
- If no SMTP-Server has been configured to send emails, the confirmation email of the MS-DROPS backend is logged. Thus, search in the logs for the confirmation email (see the end of this readme).
- After a successful deployment, the proxy [Nginx](https://www.nginx.com/) will redirect the server to `/arise/#/signin/L2FyaXNlLyMvcHJvZmlsZQ==`. Thus, this redirect is part of the [Nginx](https://www.nginx.com/) configuration.

#### List of commands
The `dev drops` environment provides the following commands:
- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_dev/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `DEV` environment
- `exit` - Close console
- \* - Help

### MS-DROPS Development environment
Setting up the development environment for the microservice drops requires a lot of configuration.

#### Deployment
Follow the upcoming steps to create your development environment:

1. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg` (default is `~/heureka/ms-drops/...` for MS-DROPS). If you change the default path, also change the path value of the `GRAV_PATH` variable in `.docker-conf/mode_dev/.env` file.
2. `bash ./heureka`
3. `dev drops` to enter the drops development environment of the CLI
4. `git clone`
5. `docker up`
6. Follow `drops up man`
7. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
8. Follow `arise up man`
9. Create an account by using the registration view on `http://localhost`.
10. Use `drops admin` to grant admin rights to your newly created user.
11. Request `/docu` to initiate an admin account for your local Grav CMS instance, the base for the documentation.
12. Initiate the navigation by calling `http://localhost/dispenser/navigation/init`. In case of a whitescreen, the call has been successfully.

#### Best practice for DEV configuration
1. Setup the required git repositories for your new MS
2. Optional: Add the repositories to the `git-setup.cfg`, if it becomes part of MS-DROPS or an infrastructure system
3. Change the database configurations in `.docker-conf/mode_dev/.env`
4. Add an nginx upstream for your local new MS in `.docker-conf/mode_dev/nginx/pool2.upstream` (see new or arise and drops as an example)
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

#### List of commands
The `dev drops` environment provides the following commands:
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


### Infrastructure development environment
Required to clone all git repositories for the development of infrastructure services like `dispenser` or `vca-widget-base`.

#### Deployment
Follow the upcoming steps to create your infrastructure development environment:

1. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg>
2. `bash ./heureka`
3. `dev infra` to enter the infrastructure environment of the CLI
4. `clone`
5. `docker up`
6. Configure the local `application.conf` in your dispenser repository to listen to `localhost:27017` (or another port, if you have changed it in your `infra.yml`)

#### List of commands
The `dev infra` environment provides the following commands:

- `clone` - Clone the required git repositories
- `rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/mode_infra/.env` file (starts the dispenser database on `localhost:27017`)
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help

### Production environment

#### Deployment
Follow the upcoming steps to create your production environment:
1. `bash ./heureka`
2. `dev prod` to enter the production environment of the CLI
3. `up`
4. Create an account by using the registration view on `http://localhost`.
5. Use `admin` to grant admin rights to your newly created user.
6. Request `/docu` to initiate an admin account for your local Grav CMS instance, the base for the documentation.
7. Initiate the navigation by calling `/dispenser/navigation/init`. In case of a whitescreen, the call has been successfully.

#### Best practice for PROD configuration
0. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg` (default is `~/heureka/...`). If you change the default path, also change the path value of the `GRAV_PATH` variable in `.docker-conf/mode_dev/.env` file.
1. Change the database configurations for MS-DROPS (`DROPS_DB_*`) and other existing microservices in `.docker-conf/mode_prod/.env`.
2. Change the application secrets of drops (`.docker-conf/mode_prod/drops/application.conf`) and dispenser (`.docker-conf/mode_prod/dispenser/application.conf`). Both should have a length of 64 characters.
3. Change the server name in `.docker-conf/mode_prod/nginx/default.conf`. Also add it to `play.filters.hosts.allowed` in `.docker-conf/mod_prod/dispenser/application.conf`.
4. Add an SSH config (on Port 443)

#### Hints for the deployment
- If no SMTP-Server has been configured to send emails, the confirmation email of the MS-DROPS backend is logged. Thus, search in the logs for the confirmation email (see the end of this readme).
- After a successful deployment, the proxy [Nginx](https://www.nginx.com/) will redirect the server to `/arise/#/signin/L2FyaXNlLyMvcHJvZmlsZQ==`. Thus, this redirect is part of the [Nginx](https://www.nginx.com/) configuration.

#### List of commands
The `dev prod` environment provides the following commands:

- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_prod/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `PROD` environment
- `exit` - Close console
- \* - Help

## Configuration files
There are several configuration files to make the MS-architecture more save:

### Docker compose configuration
The `docker-setup.cfg` describes all possible docker environments, like:
```
[ENV_PROD]
compose_files=base.yml prod.yml

[ENV_MS_DROPS]
compose_files=base.yml ms_drops.yml
```
The example shows the two different environment `ENV_PROD` and `ENV_MS_DROPS`.

- `docker-setup.cfg`
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
The `git-setup.cfg` contains the URL, the name and the branch that has to be selected of every git repository. Additionally, you can set a local file system path for the repositories (default is `~/heureka/...`).
Furthermore, you can define an microservice ("MS") by adding
```
[MS_<name>]
set=list of repositories
related=list of related MS that have to be cloned and removed, if the MS itself is cloned or removed
```

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

## Logging
Currently, the Heureka-CLI just uses the [logging implemented by Docker](https://docs.docker.com/config/containers/logging/). Thus, leave the Heureka-CLI and enter
```
sudo docker logs <container-name>
```
to show the logs of a container. See `docker ps --format '{{.Names}}'` to print the names of the running container.
```
# Print log of MS-DROPS backend service (drops)
sudo docker logs drops
```
