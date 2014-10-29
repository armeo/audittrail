## Audit Trail
Elasticsearch and Couchbase cluster on CentOS6.5

## Prequisites
[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/)

## Vagrant commands
	vagrant up 			# starts the machine
	vagrant ssh 		# ssh to the machine
	vagrant halt 		# shut down the machine
	vagrant provision 	# applies the bash and puppet provisioning
	vagrant destroy 	# delete machine

## How to ...
### Install and Configuration Couchbase
 1. Install couchbase dependency
 
		yum -y update
		yum -y install wget curl unzip pkgconfig openssl098e
 2. Download and Install couchbase

		cd /opt
		wget http://packages.couchbase.com/releases/2.5.1/couchbase-server-enterprise_2.5.1_x86_64.rpm
		rmp --install couchbase-server-enterprise_2.5.1_x86_64.rpm
 3. Start Couchbase Service
 		
		service couchbase-server start
 4. Init a couchbase cluster

		/opt/couchbase/bin/couchbase-cli cluster-init \
			-c localhost:8091 \
			-u Administrator \
			-p Couchbase@dm1n \
			--cluster-init-username=Administrator \
			--cluster-init-password=Couchbase@dm1n \
			--cluster-init-ramsize=1024
 5. Init a couchbase node
 
		/opt/couchbase/bin/couchbase-cli node-init \
			-c localhost:8091 \
			-u Administrator \
			-p Couchbase@dm1n \
			--node-init-data-path=/opt/couchbase/var/lib/couchbase/data \
			--node-init-index-path=/opt/couchbase/var/lib/couchbase/data
 6. Create a bucket

		/opt/couchbase/bin/couchbase-cli bucket-create \
			-c localhost:8091 \
			-u Administrator \
			-p Couchbase@dm1n \
			--bucket=audittrail \
			--bucket-type=couchbase \
			--bucket-password=Bucket@dm1n \
			--bucket-ramsize=512 \
			--bucket-replica=1',
 7. Configure the number of concurrent replications in xdcr

		/usr/bin/curl -X POST \
			-u Administrator \
			-p Couchbase@dm1n \
			http://localhost:8091/internalSettings \
			-d xdcrMaxConcurrentReps=8

### Install and Configuration Elasticsearch
 1. Install elasticsearch dependency
 
		yum -y install wget curl unzip pkgconfig java-1.7.0-openjdk
 2. Download and Install elasticsearch
 
		cd /opt
		wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.0.noarch.rpm
		rpm --install elasticsearch-1.1.0.noarch.rpm
 3. Config Elasticsearch
 
    Edit `/etc/elasticsearch/elasticsearch.yml`

		cluster.name: elasticsearch
		node.name: "Audit Trail"
		couchbase.username: Administrator
		couchbase.password: Couchbase@dm1n
		couchbase.defaultDocumentType: audittrail
  		couchbase.maxConcurrentRequests: 1024
 4. Install Elasticsearch plugins
 	- Transport Couchbase
		
			/usr/share/elasticsearch/bin/plugin \
				-install transport-couchbase \
				-url http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/1.3.0/elasticsearch
	- Head, A web front end for elasticsearch
		
		- `/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head`
		- `open http://localhost:9200/_plugin/head/`
 5. Start Elasticsearch Service
 
		service elasticsearch start
 6. Init Index Template

		/usr/bin/curl -X PUT \
			http://localhost:9200/_template/couchbase \
			-d @/vagrant/puppet/modules/elasticsearch/templates/index_template.json
 7. Create `audittrail` index 

		/usr/bin/curl -X PUT http://localhost:9200/audittrail
