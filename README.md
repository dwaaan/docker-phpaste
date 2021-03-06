![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/dwaaan/phpaste-docker.svg)![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/dwaaan/phpaste-docker.svg) [![](https://images.microbadger.com/badges/image/dwaaan/phpaste-docker.svg)](https://microbadger.com/images/dwaaan/phpaste-docker )

Docker image & Compose files for PASTE - https://github.com/jordansamuel/PASTE  
Paste is a project that started from the files pastebin.com used before it was bought.  

## NOT CURRENTLY WORKING ##

### Howto  

* `git clone https://github.com/dwaaan/docker-phpaste`  
* `cd docker-phpaste`  
* `chmod -R 777 www/`  
* Edit docker-compose.yml, set `MYSQL_ROOT_PASSWORD`, change port if needed (default 80)  
* `docker-compose up -d`  
* wait ~30 seconds for mysql startup & database creation  
* open http://yourip:port/install  
* enter database details:  
> database host: mysql  
> database: paste  
> username:  root  
> password:  set in `docker-compose.yml`  
* enter admin username & password
* `rm -rf www/install` - the web interface will not load until install directory is removed  
* baseurl must be set in the database - without doing this pages will not load correctly - format is hostname/ip:port  
* `docker exec -ti paste mysql -h mysql -u root -p paste`  
> enter root password from docker-compose.yml  
* `use paste; update site_info SET baseurl='172.16.50.9';`  
* `exit`
> setup complete
