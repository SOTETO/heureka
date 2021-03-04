# Heureka
A Command-Line-Interface (CLI) to start the microservice MS-DROPS. It is the base for the user management of the microservice architecture.

## Pre-Requirements
- Have a GitHub Account configured
- Git installed
- BASH
- Docker installed (and docker-compose?)
- Sudo access

## Commands
- `git clone` - Clone the required git repositories
- `git rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/docker-compose/.env.dev` file
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm drops volumes` - Remove the drops volumes. That means the database contents.
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `drops up man` - Shows a manual explaining how to setup the DROPS backend service
- `drops admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `arise up man` - Shows a manual explaining how to setup the ARISE frontend service
- `exit` - close the Heureka console
- * - Help
