#!/bin/bash

# Script to deploy or remove Docker stacks for the Terrabrasilis secondary cluster.

if [[ "$1" = "rm" ]]; then

    for STACK_NAME in `docker stack ls |tail +2 | awk {'print $1'}`
    do
        echo "removing the stack: ${STACK_NAME}"
        docker stack rm ${STACK_NAME}
    done

    docker network rm proxy
    docker network rm backend
    docker network rm agent_network

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

    docker stack deploy sgdb --compose-file ${STACK_PATH}/stacks/sgdb.yaml --detach=true
    docker stack deploy geoserver-cluster --compose-file ${STACK_PATH}/stacks/geoserver-cluster.yaml --detach=true
    docker stack deploy metadata-app --compose-file ${STACK_PATH}/stacks/metadata-app.yaml --detach=true
    docker stack deploy security --compose-file ${STACK_PATH}/stacks/security.yaml --detach=true
    docker stack deploy webapps --compose-file ${STACK_PATH}/stacks/webapps.yaml --detach=true
    docker stack deploy webapps-homologation --compose-file ${STACK_PATH}/stacks/webapps-homologation.yaml --detach=true
    docker stack deploy apis --compose-file ${STACK_PATH}/stacks/apis.yaml --detach=true
    docker stack deploy homepage-app --compose-file ${STACK_PATH}/stacks/homepage-app.yaml --detach=true
    docker stack deploy webservers-homologation --compose-file ${STACK_PATH}/stacks/webservers-homologation.yaml --detach=true
    docker stack deploy portainer --compose-file ${STACK_PATH}/start/portainer.yaml --detach=true
    sleep 60
    docker stack deploy webservers --compose-file ${STACK_PATH}/stacks/webservers.yaml --detach=true

fi