class couchbase {
	# Install pkgconfig (not all CentOS base boxes have it).
	package { 'pkgconfig':
		ensure => present,
	}->

    # Install libssl dependency
	package { 'libssl0.9.8':
		name   => 'openssl098e',
		ensure => present,
	}->

	# Download the Sources
	exec { 'couchbase-server-source':
		command => '/usr/bin/wget http://packages.couchbase.com/releases/2.5.1/couchbase-server-enterprise_2.5.1_x86_64.rpm',
		cwd     => '/opt/',
		creates => '/opt/couchbase-server-enterprise_2.5.1_x86_64.rpm',
	}->

	# Install Couchbase Server
	package { 'couchbase-server':
		provider => rpm,
		ensure   => installed,
		source   => '/opt/couchbase-server-enterprise_2.5.1_x86_64.rpm',
	}->

	# Ensure the service is running
	service { 'couchbase-server':
		ensure  => running,
		require => Package['couchbase-server']
	}->

	# Init a couchbase cluster
	exec { 'couchbase-cluster-init':
        path    => ['/usr/bin:/bin'],
		command => 'sleep 20 && /opt/couchbase/bin/couchbase-cli cluster-init \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --cluster-init-username=Administrator \
            --cluster-init-password=Couchbase@dm1n \
            --cluster-init-ramsize=1024',
		logoutput => on_failure,
	}->

	# Init a couchbase node
	exec { 'couchbase-node-init':
		command => '/opt/couchbase/bin/couchbase-cli node-init \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --node-init-data-path=/opt/couchbase/var/lib/couchbase/data \
            --node-init-index-path=/opt/couchbase/var/lib/couchbase/data',
        creates => '/opt/couchbase/var/lib/couchbase/data',
	}->

	# Create a bucket
	exec { 'couchbase-bucket-create':
		command => '/opt/couchbase/bin/couchbase-cli bucket-create \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --bucket=audittrail \
            --bucket-type=couchbase \
            --bucket-password=Bucket@dm1n \
            --bucket-ramsize=512 \
            --bucket-replica=1',
	}->

	# Configure the number of concurrent replications in xdcr
	exec { "couchbase-replication-config":
		command => "/usr/bin/curl -X POST \
			-u Administrator \
			-p Couchbase@dm1n \
			http://localhost:8091/internalSettings \
			-d xdcrMaxConcurrentReps=8",
	}
}
