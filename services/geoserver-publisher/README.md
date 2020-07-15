### Geoserver Publisher Microservices

This stack consists of three services. These services use the Python language to download files from FTP, run the GDAL command and publish new layers to Geoserver.

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
This service performs the download of images from FTP using a trigger file called geoserver.txt and performs the unzipping on the downloaded files.

#### >> raster-process
This service performs GDAL command to each image was downloaded

#### >> raster-publisher
This service consumes and sends the data to the Geoserver to publish the new layers. 

