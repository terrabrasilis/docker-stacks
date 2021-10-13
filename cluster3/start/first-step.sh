#!/bin/bash
# Before running this script, make sure all preconditions are met.
# Get the preconditions in the README of the cluster3 directory

# All these steps are described in:
# https://docs.portainer.io/v/ce-2.9/advanced/reverse-proxy/nginx#deploying-in-a-docker-swarm-scenario

# remove olds
if [[ "$1" = "rm" ]];then
  docker stack rm portainer
  docker volume rm portainer_data
  docker network rm proxy
  docker network rm agent_network
else

  # First, create two networks:
  docker network create -d overlay proxy
  docker network create -d overlay --attachable agent_network

  # Next, create the volume:
  docker volume create portainer_data

  # using an yaml file to startup Portainer stack
  docker stack deploy portainer -c portainer.yaml
fi;