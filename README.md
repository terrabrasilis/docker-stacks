# Docker Stack YAMLs - TerraBrasilis Platform

These YAML files is used to deploy all services to TerraBrasilis Platform in production mode.

## Portainer App Templates

We adopted the Portainer to manage the stacks into our Docker cluster. To turn it more easy we use the [App Templates](https://github.com/Terrabrasilis/docker-stacks/tree/master/portainer-template) to keep ours stacks definition into a public repository.

For details read [this documentation](https://portainer.readthedocs.io/en/stable/templates.html).


# Docker Stack YAMLs - FIP Cerrado Server

A set of YAML files to deploy the services that compose the GeoTiffs Publisher for interpretation team of FIP project.

See the [README file](services/geoserver-publisher) for more details.

# Docker Compose for Demonstration

A Docker Compose yaml to up the minimum containers and run the services of the WebMap.

See the [README file](demo/) for more details.
