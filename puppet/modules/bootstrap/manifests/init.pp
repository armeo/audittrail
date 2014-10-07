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

	package { 'unzip':
		ensure => present
	}

    append_if_no_such_line { "es01":
        file => '/etc/hosts',
        line => "11.11.11.11    es01.test.com    es01",
    }

    append_if_no_such_line { "cb01":
        file => '/etc/hosts',
        line => "22.22.22.22    cb01.test.com    cb01",
    }

    append_if_no_such_line { "cb02":
        file => '/etc/hosts',
        line => "33.33.33.33    cb02.test.com    cb02",
    }
}
