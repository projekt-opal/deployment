# OPAL Demo Deployment

This is a guide to install the OPAL demo.

Note: Some optional final steps are not included.
You may want to check the last section of this file first to include them.



## System preparation

Required software:

- docker-compose
- Java
- nano (or another editor)



## Elasticsearch and Fuseki

Source: https://github.com/projekt-opal/opaldata

### Download and edit config

```shell
mkdir /opt/opal-deployment ; cd /opt/opal-deployment
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
You have to edit the elasticsearch-import.properties to match your Elasticseach configuration.

```shell
mkdir /opt/opal-batch2 ; cd /opt/opal-batch2
wget https://github.com/projekt-opal/batch/releases/download/1.0.4/opal-batch.jar
wget https://raw.githubusercontent.com/projekt-opal/deployment/main/elasticsearch-import.properties
java -jar opal-batch.jar elasticsearch-import.properties
```

Afterwards, http://localhost:9200/_cat/indices?v should show the index *opal*.











## Final steps

- Ensure the containers are started after reboots
- Configure HTTPS, e.g. with https://letsencrypt.org/
- Make Fuseki and Elasticsearch read-only