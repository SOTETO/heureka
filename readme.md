# Heureka
A Command-Line-Interface (CLI) to start the microservice environment *Heureka*. It uses the concepts of OAuth2, widgets, RESTful webservices, and the Object Event System (OES) to connect collaboration services and build a microservice platform.

## Pre-Requirements
- Install Git ([https://git-scm.com/](https://git-scm.com/))
- *Optional: Configure your [GitHub account](https://docs.github.com/en/github/getting-started-with-github/set-up-git). Save a SSH public key of your systems user in your GitHub account.*
- Install docker ([https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/) - Please follow dockers instructions to install all required features!).
- Install docker-compose ([https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/))
- The Heureka-CLI is a [GNU Bash](https://www.gnu.org/software/bash/)-Script. Thus, make sure your OS has the newest version of bash installed (5.1.8 at the moment of writing).
- The Heureka-CLI requires `sudo` operations. Thus, make sure your user has `sudo` access rights.

>**Hardware:** You should have at least 4 GB working memory for using the `drops` environment of MS-DROPS.

>**Versions:** Please use always the newest versions of `git` (latest release: 2.32.0 at the moment of writing), `docker` (latest release: 20.10.8 at the moment of writing), `docker-compose` (latest release: 1.29.2 at the moment of writing) and Bash (latest release: 5.1.8 at the moment of writing)! Keep in mind that official repositories for your OS are maybe older.

>**macOS:** It is required to use volumes in docker. Thus, the [file sharing directives regarding docker have to be set](https://stackoverflow.com/questions/57819352/docker-desktop-for-macos-cant-addusr-local-folder-in-preferences-file-sharing). Just add `\/home\/user\/heureka` to the `filesharingDirectories` array in `~/Library/Group\ Containers/group.com.docker/settings.json` and restart docker afterwards.
> Furthermore, you should probably update your Bash.

>**Windows 10:** You can install the Ubuntu terminal (including Bash, other shells, and native tools) on Windows 10: [https://ubuntu.com/tutorials/ubuntu-on-windows#1-overview](https://ubuntu.com/tutorials/ubuntu-on-windows#1-overview)
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
- `new`   - Starts a wizard to initiate a development environment for a new microservice.
- `drops` - *Microservice:* Initiate a development environment for the MS-DROPS.
- `infra` - *Additional:* Initiate a development environment for infrastructure services and widget required to run the microservices.

You can also use `exit` to quit the console.

_Configuration:_ As a best practice, the configuration should always be edited _before_ the console will be used. Otherwise, the state of the console could become invalid.

### Production environment

#### Deployment
Follow the upcoming steps to create your production environment:
1. `bash ./heureka`
2. `prod` to enter the production environment of the CLI
3. `up`
4. Create an account by using the registration view on `http://localhost` (see [Hints for the deployment](#hints-for-the-deployment) - you will probably not receive a confirmation email, but it is logged).
5. Use the `admin` command of the Heureka-CLI to grant admin rights to your newly created user.
6. Request `/docu` to initiate an admin account for your local Grav CMS instance, the base for the documentation.
> Since the Grav CMS is currently not completely integrated, the Grav CMS admin account is not the same as the admin account in Heureka.
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
The `prod` environment provides the following commands:

- `up` - Start the `docker-compose up` considering the `.docker-conf/mode_prod/.env` file
- `stop` - Stop all created containers.
- `rm` - Stop and remove all docker containers described in the docker-compose files
- `rm drops volumes` - Remove the drops volumes. That means the database contents.
- `rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `leave` - Leave `PROD` environment
- `exit` - Close console
- \* - Help

### Infrastructure development environment
Required to clone all git repositories for the development of infrastructure services like `dispenser` or `vca-widget-base`.

#### Deployment
Follow the upcoming steps to create your infrastructure development environment:

1. Enter the local file system pathes of the git repositories that will be created to `git-setup.cfg>
2. `bash ./heureka`
3. `infra` to enter the infrastructure environment of the CLI
4. `clone`
5. `docker up`
6. Configure the local `application.conf` in your dispenser repository to listen to `localhost:27017` (or another port, if you have changed it in your `infra.yml`)

#### List of commands
The `infra` environment provides the following commands:

- `clone` - Clone the required git repositories
- `rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/mode_infra/.env` file (starts the dispenser database on `localhost:27017`)
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `leave` - Leave `INFRA` environment
- `exit` - close the Heureka console
- \* - Help

## Running existing microservices
Since the Heureka-CLI has been implemented to handle microservices architectures, it also allows you to add your own services. [At the end of this article adding a new microservice will be explained](#how-to-add-a-new-microservice). Subsequently, a list of default microservices is given:
- MS-DROPS (see [microservices/ms-drops/readme.md](microservices/ms-drops/readme.md))

## How to add a new microservice
The `new` command starts a wizard that creates a new microservice in the `microservice` directory. Alternatively, you can create the microservice manually.

The wizard also creates the `env.sh` file for your new microservice, implementing very basic commands for your setup:

- `up` - Clones the defined git repositories and starts the docker services by using the configured docker-compose setup.
- `rm` - Stops and removes the Docker container that have been started.
- `admin` - If the system is running, you can name admins.
- `leave` - Leave the environment
- `exit` - close the Heureka console
- \* - Help

If you want to add more docker container to your setup, change the created docker-compose file (`ms_<name>.yml`) or add more compose files in `docker-setup.cfg`.

> **Best practice:** Since Heureka uses Docker containers, it is strongly recommended to use a separated Docker container to run a database.

> **Next Step:** More information about the configuration of your newly created microservice can be found in the `readme.md` file, that has been created in your microservices directory.

### Creating a new microservice manually
Start by creating a new directory for your microservice in the `microservices/` directory:
```
mkdir microservices/ms-<name>
```
Most important: Use the given pattern for the directory name of starting with `ms-` and ending with the `<name>`. `<name>` will automtically be read by the Heureka-CLI and used afterwards as an identifier.

Afterwards, create the following required files:
- `env.sh` -- Contains the BASH functions that are mandatory to integrate the microservice setup in the console.
- `docker-setup.cfg` -- Configures the docker compose and environment files to run the microservice and its dependencies.
- `git-setup.cfg` -- Configures the git repositories required to develope the microservice.
- `ms_<name>.yml` -- The docker-compose file to run the microservices environment.
- `.docker-conf/.env` -- Configures environment variables for the docker-compose setup.
- `.docker-conf/nginx/location.pool` -- Configures the locations for the NGINX proxy
- `.docker-conf/nginx/pool2.upstream`-- Configures the upstreams for the NGINX proxy

#### Copy basic files
Just copy the following files from the `DEV NEW` environment:
- `ms_<name>.yml` from `./dev.yml` (just add the docker container required for your setup or add an additional compose file)
- `.docker-conf/.env` from `./.docker-conf/mode_dev/.env` and edit it as you want
- `.docker-conf/nginx/location.pool` from `./.docker-conf/mode_dev/nginx/location.pool` and manipulate it as required
- `.docker-conf/nginx/pool2.upstream` from `./.docker-conf/mode_dev/nginx/pool2.upstream` and manipulate it as required

#### Setup the main configuration files
Copy `docker-setup.cfg` and `git-setup.cfg` from MS-DROPS:
```
cp microservices/ms-drops/docker-setup.cfg microservices/ms-<name>/
cp microservices/ms-drops/git-setup.cfg microservices/ms-<name>/
```
Edit the files:
```docker-setup.cfg
[ENV_MS_<NAME>]
compose_files=base.yml microservices/ms-<name>/ms_<name>.yml
env_file=microservices/ms-<name>/.docker-conf/.env
```
and
```git-setup.cfg
[<name>_backend]
url=https://github.com/.../<name>_backend.git
branch=develop
name=<name>_backend
path=~/heureka/ms-<name>/<name>_backend

[<name>_frontend]
url=https://github.com/.../<name>_frontend.git
branch=develop
name=<name>_frontend
path=~/heureka/ms-<name>/<name>_frontend

[<name>_widget]
url=https://github.com/.../<name>_widget.git
branch=main
name=<name>_widget
path=~/heureka/ms-<name>/<name>_widget

[MS_<NAME>]
set=<name>_backend <name>_frontend <name>_widget
related=MS_DOCU
```
While the first three examples describe different git repositories, the last entry ([MS_<NAME>]) configures that all repositories named by the attribute `set` are the systems used as parts of the microservice. Thus, these systems are tightly coupled.
The attribute `related` names a list of all microservices that have to be cloned together with the repositories of the new microservice.

#### Required functions in `env.sh`
The `env.sh` script has to implement the following functions:
```
function <name>_command () {
  echo "<name>"
}

function <name>_command_uppercase () {
  local cmd="$(<name>_command)"
  echo ${cmd^^}
}

function <name>_description () {
  local name="MS-$(<name>_command_uppercase)"
  echo "Initiate a development environment for the $name."
}

function <name>_env () {
  # TODO - Copy from microservices/ms-drops/env.sh for an example
}
```
The `<name>_env` function in `env.sh` can and should use the following functions to become integrated: 
```
# implemented in /commands/docker
dockerRun ms_<name>
# update the current state of the system (implemented in /commands/environment
setConfig "running" "yes"
# Update the prompt (implemented in the main heureka script)
prompt=$(calcPrompt)
 ```
 ```
 # implemented in /commands/git-clone-rm. Clones also the repositories from the related microservices
 gitClone <name>
 # true means that also all repositories of the related microservices will be removed (false means delete without related services)
 gitRemove  <name> true
 ```
 
 ```
 # implemented in /commands/docker
 dockerRmVolumes ms_<name> drops-database
 ```
 
 Additionally, you can use the `man` function to format a manual output:
 ```
 function <name>_man() {
    man "MS" "MS-<uppercase-name>"
 
    echo -e "
    cmd                            Description for the cmd command
    ...                                  ...
    leave                         Leave DEV environment
    exit                            Close console
    *                                  Help
  "
  }
```
Furthermore, you should always implement a `leave` (quit the environment) and `exit` (quit the Heureka-CLI) command. Take a look at `microservices/ms-drops/env.sh` for an example.

If required, you can create as many additional scripts (e.g. in `/commands`) as you want and use it in your `env.sh`.

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

Additionally, the following files hold the docker configuration for the `ENV_PROD` and `ENV_INFRA` environments:
- `docker-setup.cfg`
- `base.yml`
- `prod.yml`
- `ìnfra.yml`
- `.docker-conf/mode_infra/.env`
- `.docker-conf/mode_prod/.env`

For a microservice environment these files are saved in a location relative to the microservices base directory (`microservices/ms-<name>`):
- `docker-setup.cfg` - by default the file uses the `base.yml` (in the directory of the Heureka-CLI) as a base for the docker-compose configuration that is extended by `ms_<name>.yml`
- `ms_<name>.yml` - contains the docker-compose specific configuration required for the setup of your microservices environment
- `.docker-conf/.env` - contains variables like used versions, ports and (internal) IP addresses used to setup the microservices environment

> **IP addresses and ports:** You can change the IP addresses and ports as you want, but keep in mind, that these values also have to be updated in the Nginx configuration as it is explained in the [Nginx configuration](#nginx-configuration).

> **Docker network:** The `base.yml` introduces an virtual docker network that is used to separate the docker container and move the internal communication to the save network. If you remove the docker network, port conflicts could emerge and handling SSL certificate handshake between microservices becomes required.

### Git configuration
The `git-setup.cfg` contains the URL, the name and the branch that has to be selected of every git repository. Additionally, you can set a local file system path for the repositories (default is `~/heureka/...`).
Furthermore, you can define an microservice ("MS") by adding
```
[MS_<name>]
set=list of repositories
related=list of related MS that have to be cloned and removed, if the MS itself is cloned or removed
```

### Nginx configuration
All environments implement their own Nginx configuration. Thus, you can change the Nginx config for one environment without side effects regarding the Nginx configuration used in another one. So, the configuration for your new microservice will not be used when you start the environment of another microservice or the production environment.

The nginx configuration for the `ENV_PROD` and `ENV_INFRA` environment are saved here:
- `.docker-conf/mode_prod/nginx/` and
- `.docker-conf/mode_infra/nginx/`

For a microservice environment, it is saved here: `microservices/ms-<name>/.docker-conf/nginx/`

There are always three files: 
- `default.conf` - contains the basic port binding (80 and 443), SSL config, and the `server_name` directive
- `location.pool` - defines the `location` directives for the nginx and thus, it separates the different systems used in the environment
- `pool2.upstream` - defines the `upstream` directives to the proxied server that are deployed by the different microservices

> **IP addresses and ports:** You can change IP addresses and ports in the `pool2.upstream` as you want, but keep in mind that these directives are pointing to webservers running in the docker container or on port different to 80 and 443 on the host machine. Thus, if you're changing the IP addresses and ports, you have to ensure that also the webservers are running on the new IP addresses and ports (e.g. by just starting them at the new configuration or manipulating the docker-compose configuration).

### Play2 configuration
The following files contain the configuration for the play2 apps for the `ENV_PROD` and `ENV_INFRA` environment:
- `.docker-conf/mode_prod/drops/application.conf`
- `.docker-conf/mode_prod/dispenser/application.conf`
- `.docker-conf/mode_infra/drops/application.conf`
- `.docker-conf/mode_infra/dispenser/application.conf`

For a microservice environment, the files are saved here: `microservices/ms-<name>/.docker-conf/drops/` and `microservices/ms-<name>/.docker-conf/dispenser/`

#### Configure databases
Change the following lines in `drops/application.conf` to setup a new database or change the IP address or port of the database container for MS-DROPS:
```
slick.dbs.default.db.user = "<user>"
slick.dbs.default.db.password = "<password>"
slick.dbs.default.db.url = "jdbc:mysql://<ip-address>:<port>/<database-name>"
```

Editing the database setup of the Dispenser service requires to change the following line in the `dispenser/application.conf`:
```
mongodb.uri = "mongodb://<ip-address>:<port>/<name>"
```

#### Changing `location` directive in Nginx
If you're changing the `location` in your [Nginx configuration](#nginx-configuration) for MS-DROPS or the dispenser service, you also have to configure the base path in the `application.conf` files. Change the follwoing line:
```
play.http.context = "/<base-path>"
```

#### Changing IP addresses of other services
If you change the IP address or the port of Nats, you have to update the `application.conf` of MS-Drops and the dispenser service:
```
nats.endpoint="nats://<ip-address>:<port>"
```

If you change the IP address or the base path of the dispenser service itself, you have to update the following line in the `dispenser/application.conf`:
```
ms.host="http://<ip-address>/<base-path>"
```
If you change the IP address or the base path of the MS-DROPS, you have to update the follwoing line in `dispenser/application.conf`:
```
drops.url.base="http://<ip-address>/<base-path>"
```
#### Dispenser OAuth configuration
After setting up an OAuth client for dispenser, you have to add it to the `dispenser/application.conf`:
```
drops.client_id="<dispenser-client_id>"
drops.client_secret="<dispenser-client_secret>"
```

#### Drops Mail service
If you're running a mail server, you can configure it by changing the following lines in the `drops/application.conf`:
```
mail.from="Drops <mailrobot@drops.vivaconagua.org>"
mail.reply="No reply <noreply@drops.vivaconagua.org>"

play.mailer {
  mock = true #(defaults to no, will only log all the email properties instead of sending an email)
  #host = localhost #(mandatory)
  # port (defaults to 25)
  # ssl (defaults to no)
  # tls (defaults to no)
  # user (optional)
  # password (optional)
  # debug (defaults to no, to take effect you also need to set the log level to "DEBUG" for the application logger)
  # timeout (defaults to 60s in milliseconds)
  # connectiontimeout (defaults to 60s in milliseconds)
}
```

#### Changing server name
If you're deploying the microservice environment on a new server with a new name, you have to configure the CORS allows hosts directives at least for the `dispenser/application.conf`. Add the new name here:
```
play.filters.hosts.allowed=["<server-name>"]
```

### Navigation configuration
- `.docker-conf/mode_prod/navigation/GlobalNav.json`
- `.docker-conf/mode_prod/navigation/noSignIn.json`

### Server name
Setting up a server name has to consider several configuration files due to a valid CORS configuration of the microservice environment. You have to set the server name in the following files:
- `nginx/default.conf` (see [Nginx configuration](#nginx-configuration))
- `drops/application.conf` (see [Play2 configuration](#play2-configuration))
- `dispenser/application.conf` (see [Play2 configuration](#play2-configuration))

## Logging
Currently, the Heureka-CLI just uses the [logging implemented by Docker](https://docs.docker.com/config/containers/logging/). Thus, leave the Heureka-CLI and enter
```
sudo docker logs <container-name>
```
to show the logs of a container. See `docker ps --format '{{.Names}}'` to print the names of the running container.

Print log of MS-DROPS backend service (drops):
```
sudo docker logs drops
```

## Troubleshooting
### Error `502` in browser
If you are continously receiving `502` errors, maybe one or more docker container are continously restarting. It sometimes happens that container get corrupted. 

__Solution__
Check, if there are continously restarting docker container by `sudo docker ps` in your terminal. If there are some container, check their logs for more information. If you see no problem, try a restart:
Use `rm` on your Heureka-CLI and `up` afterwards. In most cases this will solve the trouble.