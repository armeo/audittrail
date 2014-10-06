class xdcr {
    # init a xdcr server
    exec { "couchbase-xdcr-init":
        command => "/opt/couchbase/bin/couchbase-cli xdcr-setup \
        -c localhost:8091 \
        -u Administrator \
        -p Couchbase@dm1n \
        --create \
        --xdcr-cluster-name=elasticsearch \
        --xdcr-hostname=11.11.11.11:9091 \
        --xdcr-username=Administrator \
        --xdcr-password=Couchbase@dm1n",
    }->

    #xdcr-replication-mode=capi is important: version2 protocal is not allowed
    exec { "couchbase-xdcr-audittrail":
        path => ['/usr/bin:/bin'],
        command => "sleep 10 && /opt/couchbase/bin/couchbase-cli xdcr-replicate \
        -c localhost:8091 \
        -u Administrator \
        -p Couchbase@dm1n \
        --create \
        --xdcr-cluster-name=elasticsearch \
        --xdcr-from-bucket=audittrail \
        --xdcr-to-bucket=audittrail \
        --xdcr-replication-mode=capi",
        logoutput => on_failure,
    }
}
