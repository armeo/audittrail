class xdcr {
    # init a xdcr server
    exec { "couchbase-xdcr-init":
        command => "/opt/couchbase/bin/couchbase-cli xdcr-setup \
        -c localhost:8091 \
        -u Administrator \
        -p Couchbase@dm1n \
        --create \
        --xdcr-cluster-name=ES \
        --xdcr-hostname=localhost:9091 \
        --xdcr-username=Administrator \
        --xdcr-password=Xdcr@dm1n",
        require => [Class['couchbase'],Class['elasticsearch']]
    }

    #xdcr-replication-mode=capi is important: version2 protocal is not allowed
    exec { "couchbase-xdcr-audittrail":
        path => ['/usr/bin:/bin'],
        command => "sleep 10 && /opt/couchbase/bin/couchbase-cli xdcr-replicate \
        -c localhost:8091 \
        -u Administrator \
        -p Couchbase@dm1n \
        --create \
        --xdcr-cluster-name=ES \
        --xdcr-from-bucket=audittrail \
        --xdcr-to-bucket=audittrail \
        --xdcr-replication-mode=capi",
        logoutput => on_failure,
        require => [Exec['couchbase-xdcr-init']]
    }
}
