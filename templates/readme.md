# Heureka-CLI environment of a new microservice
The newly created environment to develop or integrate a new microservice requires a bit of configuration effort.

> The following readme uses the placeholder `<name>` for the name of your microservice. So, replace it by the name that you have defined in the wizard or while creating it by hand.

## Deployment
Follow the upcoming steps to create your development environment:

1. `bash ./heureka`
2. `<name>` to enter the development environment of the CLI
3. Start your application using all required ports except the ports used in `ms_<name>.yml` (heureka uses ports 80, 443, 9000 and 4222 by default).
4. Edit the placeholder upstream `new` in `.docker-conf/nginx/pool2.upstream` and add more required upstreams (the ports at the localhost used by your application).
5. Use the new / updated upstreams in `.docker-conf/nginx/location.pool` by introducing new pathes or editing the plaeholder path `/new`.
6. `up`
7. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
8. Create an account by using the registration view on `http://localhost` 	(see [Hints for the deployment](#hints-for-the-deployment) - you will probably not receive a confirmation email, but it is logged).
9. Use the `admin` command of the Heureka-CLI to grant admin rights to your newly created user.
10. Initiate the navigation by calling `http://localhost/dispenser/navigation/init`. In case of a whitescreen, the call has been successfully.
11. Setup an OAuth client using the Heureka web-ui and add the new `client_id` and `client_secret` to the configuration of the dispenser service, as it is explained in [the configuration of the Play2 apps](https://github.com/SOTETO/heureka#dispenser-oauth-configuration).

> **Base path:** After all, your microservice will be available by calling `http://localhost/new` (or the pathes that you have introduced). Your application has to know the base path to generate appropriate server repsonses and interprete the given path of HTTP requests. Thus, you have to configure it, if you are running your application behind a base path like `/new`.

Using the default `ms_<name>.yml`, the REST-API of MS-DROPS will be available by calling `http://localhost/drops/<endpoint>` or `http://localhost:9000/<endpoint>` and the NATS listens to `localhost:4222`. Keep in mind that you have to configure an API user to call the REST-API of MS-DROPS or execute the OAuth handshake.

## Best practice for development of new MS
1. Setup the required git repositories for your new MS.
2. Add the repositories to the `default.conf`.
3. Change the database configurations for MS-DROPS (`DROPS_DB_*`) and other existing microservices in `.docker-conf/.env`.
4. Add an nginx upstream for your local new MS in `.docker-conf/nginx/pool2.upstream` (see new or arise and drops as an example).
5. Add new locations to the nginx `.docker-conf/nginx/location.pool` file (using the new upstreams).

If you want to add more docker container to your setup, change the created docker-compose file (`ms_<name>.yml`) or add more compose files in `default.conf`. See [Docker Compose Docs](https://docs.docker.com/compose/) for more information.

In the case you want to merge or add your own docker compose file, please also consider [the hints in the general Heureka-CLI documentation](https://github.com/SOTETO/heureka#docker-compose-configuration). Furthermore, you should also keep in mind that relative pathes in docker compose files have their origin in the path that is used to *run* docker compose (the Heureka base directory). Thus, all relative pathes should be relative to the Heureka base directory.

> **Best practice:** Since Heureka uses Docker containers, it is strongly recommended to use a separated Docker container to run a database. Furthermore, use a restarting directive (`unless-stopped` or `always` - see [Docker Docs](https://docs.docker.com/config/containers/start-containers-automatically/)) to have the database available without manually starting it every time.

## Hints for the deployment
- If no SMTP-Server has been configured to send emails, the confirmation email of the MS-DROPS backend is logged. Thus, search in the logs for the confirmation email (see the end of this readme).
- After a successful deployment, the proxy [Nginx](https://www.nginx.com/) will redirect the server to `/arise/#/signin/L2FyaXNlLyMvcHJvZmlsZQ==`. Thus, this redirect is part of the [Nginx](https://www.nginx.com/) configuration.

## List of commands
- `up` - Clones the defined git repositories and starts the docker services by using the configured docker-compose setup.
- `rm` - Stops and removes the Docker container that have been started.
- `admin` - If the system is running, you can name admins.
- `leave` - Leave the environment
- `exit` - close the Heureka console
- \* - Help

# Configuration
Take a look at the [main Readme file](https://github.com/SOTETO/heureka#configuration-files) to learn more about the docker, nginx and general confguration of your environment.

# Logging
Currently, the Heureka-CLI just uses the [logging implemented by Docker](https://docs.docker.com/config/containers/logging/). Thus, leave the Heureka-CLI and enter
```
sudo docker logs <container-name>
```
to show the logs of a container. See `docker ps --format '{{.Names}}'` to print the names of the running container.

Print log of MS-DROPS backend service (drops):
```
sudo docker logs drops
```

# Publishing
Create a new branch that names your new microservice configuration and push it to GitHub. Afterwards, you can create a pull request into the `dev` branch on GitHub and your new microservice configuration will be reviewed and merged after a successful review.

For a production environment, you should keep in mind that docker images are required and no development mode can be used.