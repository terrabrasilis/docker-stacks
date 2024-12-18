# Standalone tasks - TerraBrasilis Platform

The standalone task area was defined to allocate an environment external to TerraBrasilis where some tasks will be executed. These tasks can be: database backups, ETL routines or to deploy some Apps used to manage the TerraBrasilis platform.

The main motivation is to allow the isolation of tasks and software of indirect use, reducing the attack surface.
Another motivation is to reduce the interference of tasks that use a lot of resources on the Apps of the platform that expose services and resources externally.


## The backup tasks


There are two tasks in this section, for Postgres and for MongoDB.

### Postgres

Used to produce a dump of each Postgres database based on the list of database names readed from the "public.databases_for_bkp" table inside the manager database commonly called "postgres".

 > More in the repository: https://github.com/terrabrasilis/backup-pg-dump

### MongoDB

Used to produce a copy of all documents, for a specific MongoDB instance used by the Business API, and store it in the ZIP file.

 > More in the repository: https://github.com/terrabrasilis/backup-mongo


## Manager Apps

Deploy some Apps used to manager databases like PgAdmin4 for Postgres and phpMyAdmin for Mysql.

 > See the manager-apps.yaml

## Permanent tasks

Some tasks used to produce data for non-TerraBrasilis purposes.

 > See the permanent-tasks.yaml

In the future that tasks can be migrated to AirFlow environment.

## On demand tools

Some tasks used on demand to provide specific analysis of some components of the TerraBrasilis platform, such as GeoServer.

 > See the on-demand-tools.yaml

## Apache AirFlow

An environment to organize processes. We expect all ETL routines to be migrated to this environment.


 > See the airflow.yaml