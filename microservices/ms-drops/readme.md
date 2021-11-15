# MS-DROPS Development environment
Setting up the development environment for the microservice drops requires a lot of configuration.

## Deployment
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

## Best practice for DEV configuration
1. Setup the required git repositories for your new MS
2. Optional: Add the repositories to the `git-setup.cfg`, if it becomes part of MS-DROPS or an infrastructure system
3. Change the database configurations in `.docker-conf/mode_dev/.env`
4. Add an nginx upstream for your local new MS in `.docker-conf/mode_dev/nginx/pool2.upstream` (see new or arise and drops as an example)
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

## List of commands
The `dev drops` environment provides the following commands:
- `git clone` - Clone the required git repositories
- `git rm` - Remove the git repositories
- `docker up` - Start the `docker-compose up` considering the `.docker-conf/mode_dev_ms_drops/.env` file
- `docker rm` - Stop and remove all docker containers described in the docker-compose file
- `docker rm drops volumes` - Remove the drops volumes. That means the database contents.
- `docker rm dispenser volumes` - Remove the dispenser volumes. That means the database contents.
- `drops up man` - Shows a manual explaining how to setup the DROPS backend service
- `drops admin` - Sets admin access rights in DROPS for a specific user identified by its email address
- `drops init` - Initiates the Drops database. Requires a running Drops backend.
- `arise up man` - Shows a manual explaining how to setup the ARISE frontend service
- `leave` - Leave `DEV` environment
- `exit` - close the Heureka console
- \* - Help