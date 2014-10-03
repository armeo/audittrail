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
        timeout => 1800,
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
	}
}
