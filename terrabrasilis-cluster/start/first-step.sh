#!/bin/bash
# Before running this script, make sure all preconditions are met.
# Get the preconditions in the README file

# All these steps are described in:
# https://docs.portainer.io/v/2.20/start/install-ce/server/swarm

# remove olds
if [[ "$1" = "rm" ]];then
  docker stack rm portainer
  docker network rm proxy
  docker network rm backend
  docker network rm agent_network
else

  # First, create two networks:
  docker network create -d overlay proxy
  docker network create -d overlay backend
  docker network create -d overlay --attachable agent_network

  # using an yaml file to startup Portainer stack
  docker stack deploy portainer -c portainer.yaml
fi;