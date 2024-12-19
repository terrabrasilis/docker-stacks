# AirFlow

Here we discuss the deployment and configuration of AirFlow to serve the TerraBrasilis platform.

## How to deploy

We use a Docker stack to deploy all Apache AirFlow components to Docker Swarm, as can be seen in the airflow.yaml file.

As part of the deployment process, we define a directory on the server where the stack will run, to be used as a volume by AirFlow containers. This location must be empty and will be populated by AirFlow.

Another prerequisite is that a PostgreSQL database must be created and the information to connect to it must be provided to AirFlow. In Docker Swarm, the best option to do this is via secrets, so we must create two secrets, as in the example:

```sh
printf "postgresql://postgres:postgres@ip_or_hostname:5432/airflow" | docker secret create airflow_database_sql_alchemy_conn -
printf "db+postgresql://postgres:postgres@ip_or_hostname:5432/airflow" | docker secret create airflow_celery_result_backend_conn -
```

After the start, we have the following directories and files:

```sh
/logs/
/dags/
/plugins/
/sources/
/projects/

airflow.cfg
airflow-webserver.pid
webserver_config.py
```

## How to configure

Some configuration details to enable the use of specific features.

### To deploy new DAGs

We adopted DagBag as a means to publish new DAGs by cloning code repositories directly into the project directory.

Explanation to be done...

### To send email

To use send email alerts we need ...

Explanation to be done...

### To use Python virtual env

To use PythonVirtualEnvOperator ...

Explanation to be done...