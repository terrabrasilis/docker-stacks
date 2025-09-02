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
    # docker stack deploy --compose-file ${STACK_PATH}/stacks/security.yaml --detach=false --resolve-image changed security

    docker stack deploy --compose-file ${STACK_PATH}/stacks/sgdb.yaml --detach=false --resolve-image changed sgdb
    docker stack deploy --compose-file ${STACK_PATH}/stacks/geoserver-cluster.yaml --detach=false --resolve-image changed geoserver-cluster
    docker stack deploy --compose-file ${STACK_PATH}/stacks/metadata-app.yaml --detach=false --resolve-image changed metadata-app
    docker stack deploy --compose-file ${STACK_PATH}/stacks/webapps.yaml --detach=false --resolve-image changed webapps
    docker stack deploy --compose-file ${STACK_PATH}/stacks/webapps-homologation.yaml --detach=false --resolve-image changed webapps-homologation
    docker stack deploy --compose-file ${STACK_PATH}/stacks/apis.yaml --detach=false --resolve-image changed apis
    docker stack deploy --compose-file ${STACK_PATH}/stacks/homepage-app.yaml --detach=false --resolve-image changed homepage-app
    docker stack deploy --compose-file ${STACK_PATH}/stacks/webservers-homologation.yaml --detach=false --resolve-image changed webservers-homologation
    docker stack deploy --compose-file ${STACK_PATH}/start/portainer.yaml --detach=false --resolve-image changed portainer

    # waiting for the services to be fully started before starting the nginx proxy
    sleep 30
    docker stack deploy --compose-file ${STACK_PATH}/stacks/webservers.yaml --detach=false --resolve-image changed webservers

fi
