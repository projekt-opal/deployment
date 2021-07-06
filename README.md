# OPAL Demo Deployment

This is a guide to install the OPAL demo.

Note: Some optional final steps are not included.
Check section [final steps](#final-steps) the last section of this file first to include them during the deployment.



## System preparation

Required software:

- docker-compose, https://docs.docker.com/compose/install/
- Java, https://wiki.ubuntuusers.de/Java/Installation/
- nano (or another editor); wget; zip
- node, https://github.com/nodesource/distributions



## Elasticsearch and Fuseki

Source: https://github.com/projekt-opal/opaldata

### Download and configuration

```shell
mkdir /opt/opal-data ; cd /opt/opal-data
wget -O opaldata-master.zip https://github.com/projekt-opal/opaldata/archive/refs/heads/master.zip
unzip opaldata-master.zip ; cd opaldata-master/
nano .env
```

You can use the following configuration, just add a password:

```properties
FUSEKI_ADMIN_PASSWORD=
FUSEKI_JVM_ARGS=-Xmx2g
ELASTICSEARCH_JAVA_OPTS=-Xmx2g
```

Build the containers:

```shell
docker-compose up --build -d
```

Wait some seconds until opaldata-master_elasticsearch-initialization ended.  
You can check it via `sudo docker ps -a`.

Afterwards, the backends should be available at addresses similar to:

- http://localhost:3030/
- http://localhost:9200/_cat/indices?v



## Import data

### Download data

Download and extract data to temporary directory.
26 ttl files will be available.

```shell
mkdir /tmp/opal-data ; cd /tmp/opal-data
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/get-data.sh
chmod +x get-data.sh ; ./get-data.sh
```

### Import data to Elasticsearch

Source: https://github.com/projekt-opal/batch

The following code imports the ttl files into Elasticsearch in around 10 minutes.
You have to edit the file *elasticsearch-import.properties* to match your Elasticseach configuration.

```shell
mkdir /opt/opal-batch ; cd /opt/opal-batch
wget https://github.com/projekt-opal/batch/releases/download/1.0.4/opal-batch.jar
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/elasticsearch-import.properties
java -jar opal-batch.jar elasticsearch-import.properties
```

Afterwards, http://localhost:9200/_cat/indices?v should show the index *opal*.

### Import data to Fuseki

- Open the Fuseki frontend for managing datasets: http://localhost:3030/manage.html
- Add a new persistent (TDB2) dataset with name *2020-10*
- Upload the ttl files (edp, govdata, mcloud, mdm) from https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-11-18/2020-10/
- Add a new persistent (TDB2) dataset with name *2020-06*
- Upload the ttl files (edp, govdata, mcloud, mdm) from https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-10-22/2020-06/





## Frontend installation

### Webservices (TODO, not complete)

Source: https://github.com/projekt-opal/web-service

```shell
mkdir /opt/opal-webservices ; cd /opt/opal-webservices
wget -O web-service-master.zip https://github.com/projekt-opal/web-service/archive/refs/heads/master.zip
unzip web-service-master.zip ; cd web-service-master
nano opal-webservices.properties
```

Provide a configuration that is similar to the following lines.
Edit the values, if you changed the imported Fusiki data above.
The URLs should contain the domain will be open to the public.

```properties
sparql.endpoint.previous=http://localhost:3030/2020-06/
sparql.endpoint.previous.title=OPAL 2020-06
sparql.endpoint.current=http://localhost:3030/2020-10/
sparql.endpoint.current.title=OPAL 2020-10
geo.url.prefix=http://localhost:3000/view/datasetView?uri=
geo.redirect=http://localhost:8081/getGeoDatasetsHtml
```

Additionally, an *.env* file containing the Elasticsearch configuration is required.

```
ES_INDEX=opal
OPAL_ELASTICSEARCH_URL=localhost
OPAL_ELASTICSEARCH_PORT=9200
```

Finally, build the webservices component:

```shell
docker-compose up --build -d
```

### Web User Interface

Source: https://github.com/projekt-opal/web-ui

```shell
mkdir /opt/opal-webservices ; cd /opt/opal-webservices
wget -O web-service-master.zip https://github.com/projekt-opal/web-service/archive/refs/heads/master.zip
unzip web-service-master.zip ; cd web-service-master
nano opal-webservices.properties
```



## Final steps

- Ensure the containers are started after reboots
- Configure HTTPS, e.g. with https://letsencrypt.org/
- Make Fuseki and Elasticsearch read-only