# Heureka-CLI environment of a new microservice
The newly created environment to develop or integrate a new microservice requires a bit of configuration effort.

## Deployment
Follow the upcoming steps to create your development environment:

1. `bash ./heureka`
2. `<name>` to enter the development environment of the CLI
3. Start your application using all required ports except the ports used in `ms_<name>.yml` (heureka uses ports 80, 443, 9000 and 4222 by default).
4. Edit the placeholder upstream `new` in `.docker-conf/mode_dev/nginx/pool2.upstream` and add more required upstreams (the ports at the localhost used by your application).
5. Use the new / updated upstreams in `.docker-conf/mode_dev/nginx/location.pool` by introducing new pathes or editing the plaeholder path `/new`.
6. `up`
7. Call `http://localhost/drops/` to initiate the drops DB. Notice that the server requires up to 30 seconds to answer this call.
8. Create an account by using the registration view on `http://localhost`.
9. Use `admin` to grant admin rights to your newly created user.
10. Initiate the navigation by calling `http://localhost/dispenser/navigation/init`. In case of a whitescreen, the call has been successfully.

After all, your microservice will be available by calling `http://localhost/new` (or the pathes that you have introduced). Using the default `ms_<name>.yml`, the REST-API of MS-DROPS will be available by calling `http://localhost/drops/<endpoint>` or `http://localhost:9000/<endpoint>` and the NATS listens to `localhost:4222`. Keep in mind that you have to configure an API user to call the REST-API of MS-DROPS or execute the OAuth handshake.

## Best practice for development of new MS
1. Setup the required git repositories for your new MS.
2. Add the repositories to the `git-setup.cfg`.
3. Change the database configurations for MS-DROPS (`DROPS_DB_*`) and other existing microservices in `.docker-conf/.env`.
4. Add an nginx upstream for your local new MS in `.docker-conf/nginx/pool2.upstream` (see new or arise and drops as an example).
5. Add new locations to the nginx `.docker-conf/mode_dev/nginx/location.pool` file (using the new upstreams).

If you want to add more docker container to your setup, change the created docker-compose file (`ms_<name>.yml`) or add more compose files in `docker-setup.cfg`.

> **Best practice:** Since Heureka uses Docker containers, it s strongly recommended to use a separated Docker container to run a database.

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

# Logging
Currently, the Heureka-CLI just uses the [logging implemented by Docker](https://docs.docker.com/config/containers/logging/). Thus, leave the Heureka-CLI and enter
```
sudo docker logs <container-name>
```
to show the logs of a container. See `docker ps --format '{{.Names}}'` to print the names of the running container.
```
# Print log of MS-DROPS backend service (drops)
```
sudo docker logs drops
```