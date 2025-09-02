#!/bin/bash

# Script to deploy or remove Docker stacks for the Terrabrasilis secondary cluster.

if [[ "$1" = "rm" ]]; then

    for STACK_NAME in `docker stack ls |tail +2 | awk {'print $1'}`
    do
        echo "removing the stack: ${STACK_NAME}"
        docker stack rm --detach=false ${STACK_NAME}
    done

    sleep 10
    docker network prune -f
    docker volume prune -f

else

    # update stacks repository
    cd /home/andre/docker-stacks/
    git pull origin master

    STACK_PATH="/home/andre/docker-stacks/terrabrasilis-cluster"

    # Disable because we get the error to repull the images from docker hub after a wile. error: "Too many requests: You have reached your pull rate limit"
    #docker system prune --filter "until=24h" -f

    docker network create -d overlay proxy
    docker network create -d overlay backend
    docker network create -d overlay --attachable agent_network

    sleep 10

    # the security stack has a keycloak application that does not work on a read-only database, so we keep that stack disabled for now.
    # docker stack deploy security --compose-file ${STACK_PATH}/stacks/security.yaml --detach=false

    docker stack deploy sgdb --compose-file ${STACK_PATH}/stacks/sgdb.yaml --detach=false
    docker stack deploy geoserver-cluster --compose-file ${STACK_PATH}/stacks/geoserver-cluster.yaml --detach=false
    docker stack deploy metadata-app --compose-file ${STACK_PATH}/stacks/metadata-app.yaml --detach=false
    docker stack deploy webapps --compose-file ${STACK_PATH}/stacks/webapps.yaml --detach=false
    docker stack deploy webapps-homologation --compose-file ${STACK_PATH}/stacks/webapps-homologation.yaml --detach=false
    docker stack deploy apis --compose-file ${STACK_PATH}/stacks/apis.yaml --detach=false
    docker stack deploy homepage-app --compose-file ${STACK_PATH}/stacks/homepage-app.yaml --detach=false
    docker stack deploy webservers-homologation --compose-file ${STACK_PATH}/stacks/webservers-homologation.yaml --detach=false
    docker stack deploy portainer --compose-file ${STACK_PATH}/start/portainer.yaml --detach=false

    # waiting for the services to be fully started before starting the nginx proxy
    sleep 60
    docker stack deploy webservers --compose-file ${STACK_PATH}/stacks/webservers.yaml --detach=false

fi
