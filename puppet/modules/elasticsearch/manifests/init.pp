class elasticsearch {
    package { 'java-1.7.0-openjdk':
        ensure => present,
    }->

    # Download the Sources
    exec { 'elasticsearch-source':
        command => '/usr/bin/wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.0.noarch.rpm',
        cwd     => '/opt/',
        creates => '/opt/elasticsearch-1.1.0.noarch.rpm',
    }->

    # Install Elasticsearch
    package { 'elasticsearch':
        provider => rpm,
        ensure   => installed,
        source   => '/opt/elasticsearch-1.1.0.noarch.rpm',
        require  => Package['java-1.7.0-openjdk'],
    }->

	# Config Elasticsearch
	file { 'elasticsearch.yml':
		owner   => 'root',
		path    => '/etc/elasticsearch/elasticsearch.yml',
		content => template('elasticsearch/elasticsearch.yml.erb'),
	}->

    #Install Elasticsearch plugins
    exec { 'transport-couchbase':
        command => '/usr/share/elasticsearch/bin/plugin -install transport-couchbase -url http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/1.3.0/elasticsearch-transport-couchbase-1.3.0.zip',
        creates => '/usr/share/elasticsearch/plugins/transport-couchbase',
    }->
    exec { 'elasticsearch-head':
        command => '/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head',
        creates => '/usr/share/elasticsearch/plugins/head',
    }->
    exec { 'elasticsearch-kopf':
        command => '/usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf',
        creates => '/usr/share/elasticsearch/plugins/kopf',
    }->
    exec { 'elasticsearch-HQ':
        command => '/usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ',
        creates => '/usr/share/elasticsearch/plugins/HQ',
    }->

    service {'elasticsearch':
        ensure  => running,
        require => Package['elasticsearch']
    }->

    # Init Index
    exec { "index-template":
        path      => ['/usr/bin:/bin'],
        command   => "sleep 10 && curl -X PUT http://localhost:9200/_template/couchbase -d @/vagrant/puppet/modules/elasticsearch/templates/index_template.json",
        require   => Service["elasticsearch"],
        logoutput => on_failure,
    }->

    exec { "cprofile-real":
        path    => ['/usr/bin:/bin'],
        command => "sleep 10 && curl -X PUT http://localhost:9200/audittrail",
    }
}
