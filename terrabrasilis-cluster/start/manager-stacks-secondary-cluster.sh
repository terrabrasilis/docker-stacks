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

    docker system prune -f

else

    cd /home/andre/docker-stacks/terrabrasilis-cluster/stacks/

    docker network create -d overlay proxy
    docker network create -d overlay backend
    docker network create -d overlay --attachable agent_network

    docker stack deploy sgdb --compose-file sgdb.yaml --detach=true
    docker stack deploy geoserver-cluster --compose-file geoserver-cluster.yaml --detach=true
    docker stack deploy metadata-app --compose-file metadata-app.yaml --detach=true
    docker stack deploy security --compose-file security.yaml --detach=true
    docker stack deploy webapps --compose-file webapps.yaml --detach=true
    docker stack deploy webapps-homologation --compose-file webapps-homologation.yaml --detach=true
    docker stack deploy apis --compose-file apis.yaml --detach=true
    docker stack deploy homepage-app --compose-file homepage-app.yaml --detach=true
    docker stack deploy webservers-homologation --compose-file webservers-homologation.yaml --detach=true
    docker stack deploy portainer -c portainer.yaml --detach=true
    sleep 60
    docker stack deploy webservers --compose-file webservers.yaml --detach=true

fi