# OPAL Demo Deployment

This is a guide to install the OPAL demo.

Some optional final steps are not included.
Check [additional configuration](#additional-configuration) first to include them during the deployment.



## System preparation

Required software:

- docker-compose (https://docs.docker.com/compose/install/)
- Java (https://wiki.ubuntuusers.de/Java/Installation/)
- nano (or another editor) ; wget ; zip



## Elasticsearch and Fuseki

(Source: https://github.com/projekt-opal/opaldata)

Download:

```shell
mkdir /opt/opal-data ; cd /opt/opal-data
wget -O opaldata-master.zip https://github.com/projekt-opal/opaldata/archive/refs/heads/master.zip
unzip opaldata-master.zip ; cd opaldata-master/
```

Edit the `.env` configuration file and set the `FUSEKI_ADMIN_PASSWORD`:

```shell
nano .env
```

Build the containers:

```shell
docker-compose up --build -d
```

Wait some seconds until opaldata-master_elasticsearch-initialization ended.  
You can check it via `sudo docker ps -a`.

Afterwards, the backends should be available at:

- http://localhost:3030/
- http://localhost:9200/_cat/indices?v



## Import data

### Download data

Download and extract data to temporary directory,
26 ttl files will be available.

```shell
mkdir -p /opt/opal-import/ttl ; cd /opt/opal-import/ttl
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/get-data.sh
chmod +x get-data.sh ; ./get-data.sh
```



### Import data to Elasticsearch

(Source: https://github.com/projekt-opal/batch)

Download the batch component and configuration file:

```shell
mkdir -p /opt/opal-import/ ; cd /opt/opal-import/
wget https://github.com/projekt-opal/batch/releases/download/1.0.4/opal-batch.jar
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/elasticsearch-import.properties
```

You only have to edit the file `elasticsearch-import.properties` if you changed your Elasticseach configuration.
The following code imports the ttl files into Elasticsearch in around 10 minutes.

```shell
java -jar opal-batch.jar elasticsearch-import.properties
```

Afterwards, http://localhost:9200/_cat/indices?v should show millions of documents for the index *opal*.

### Import data to Fuseki

- Open the Fuseki frontend for managing datasets: http://localhost:3030/manage.html
- Add a new persistent (TDB2) dataset with name *2020-10*
- Add a new persistent (TDB2) dataset with name *2020-06*

Execute the script to import data, it takes around 30 minutes:

```shell
mkdir -p /opt/opal-import/ ; cd /opt/opal-import/
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/import-fuseki.sh
chmod +x import-fuseki.sh ; ./import-fuseki.sh
```



## Frontend installation

### Webservices

(Source: https://github.com/projekt-opal/web-service)

Download:

```shell
mkdir /opt/opal-webservices ; cd /opt/opal-webservices
wget -O web-service-master.zip https://github.com/projekt-opal/web-service/archive/refs/heads/master.zip
unzip web-service-master.zip ; cd web-service-master
```

Edit the `.env` configuration file.
The values for keys with prefix *geo* will be used from users webbrowsers and require final domains (not localhost):

```properties
# Elasticsearch configuration
OPAL_ELASTICSEARCH_URL=localhost
OPAL_ELASTICSEARCH_PORT=9200
ES_INDEX=opal

# SPARQL endpoint for previously crawled dataset
SPARQL_ENDPOINT_PREVIOUS=http://localhost:3030/2020-06/

# SPARQL endpoint for latest crawled dataset
SPARQL_ENDPOINT_LATEST=http://localhost:3030/2020-10/

# Will be added as parameter 'urlPrefix' in GEO_REDIRECT URL
GEO_URL_PREFIX=http://localhost:3000/view/datasetView?uri=

# URL to redirect to when map bounding box was selected by user
GEO_REDIRECT=http://localhost:8081/getGeoDatasetsHtml
```

Finally, build the webservices component:

```shell
docker-compose up --build -d
```

You can check the webservice configuration at http://localhost:8081/opalinfo



### Web User Interface

(Source: https://github.com/projekt-opal/web-ui)

```shell
mkdir /opt/opal-ui ; cd /opt/opal-ui
wget -O web-ui-master.zip https://github.com/projekt-opal/web-ui/archive/refs/heads/master.zip
unzip web-ui-master.zip ; cd web-ui-master
```

Create an `.env` file and set the URL for the webservices created before:

```properties
BACKEND_ADDRESS=http://localhost:8081/
```

The UI will start at port 3000.
To change it, edit `docker-compose.yml`.

Finally, build the UI component:

```shell
docker-compose build --no-cache
docker-compose up -d
```

Access the UI at http://localhost:3000/



## Additional configuration

- Ensure the containers are started after reboots
- Configure HTTPS, e.g. with https://letsencrypt.org/
- Make Fuseki and Elasticsearch read-only
