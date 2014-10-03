class bootstrap {
	Exec {
		path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/local/sbin']
	}

	# Ensure firewall is off (some CentOS images have firewall on by default).
	service { 'iptables':
		ensure => stopped,
		enable => false
	}

	package { 'wget':
		ensure => present
	}

	package { 'curl':
		ensure => present
	}

	package { 'sed':
		ensure => present
	}

	package { 'unzip':
		ensure => present
	}
}
