### Geoserver Publisher Microservice

This service uses the entire functionality of Python language to download FTP, to execute GDAL command and consume to publish new layers into Geoserver.
Neither of these services uses shell scripts anymore, just the Python libraries to execute all necessities.

Location of yaml and deploy.sh file into server FIP-SERVICE, see directory:`cd /data/raster` 

These services need some folders, they are: 
1. config (where configs to all services are)
2. download (where the download is performed)
3. log (logs of all services)
4. processed (where the `raster-process` service store the processed image to be published)

To deploy the services stack:
1. `cd /data/raster`
2. `sh deploy.sh`

To undeploy the services stack:
1. `cd /data/raster`
2. `sh undeploy.sh`

To follow logs in real time:
1. `cd /data/raster`
2. `sh log.sh`

#### >> raster-ftp-download
This service performs the images download

#### >> raster-process
This service performs GDAL command to each image was downloaded

#### >> raster-publisher
This service consumes and send to Geoserver the data to publish one new layer. 

