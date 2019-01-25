#### Author : Sidharth
#### Date : Jan 25, 2019
# Docker-Superset-Setup
## Dockerfile
1. Python Requirements are in requirements.txt
2. Environment variables are set inside the Dockerfile.
3. Refer Dockerfile for Application specific changes.
```
    $ docker build --tag couture-dashboard:latest .
    $ docker run --name CONTAINER-NAME -tid -p 8088:8088 -v supersetdb:/home/couture/.superset couture-dashboard:latest
    $ docker exec -it CONTAINER-NAME /bin/bash //for ssh into container
```

## docker-compose.yml
1. We have setup 4 applications - redis, rabbitmq, mysql, superset.
2. Redis, rabbitmq, and mysql are there in the docker-compose.yml just to make it a standard template which can be used to setup other multi-container  applications.
3. Linking among these application will be application specific.
4. We have specified and env_file for Environment Variables which are stored in 'list.env'.
5. Container name is specified as 'couture-dashboard'. If we want to launch multiple replicas, we should remove the container name.
6. Volume has been specified for the /home/couture/.superset/ folder for persistent storage of dashboards and users in the superset. Volume name is supersetdb. We are assuming that a previous volume already exists so in the docker-compose.yml we have specified:
```
    volumes:
        supersetdb:
            external: true 
```
Which means that superset will not launch its own volume it will use the existing one. It will give error if the 'supersetdb' volume doesn't exist.

7. superset_config.py can also be used to communicate with mysql and redis services as mentioned in the official superset docker-compose.yml.
```
    $ docker-compose up superset
```
