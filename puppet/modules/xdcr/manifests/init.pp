class xdcr {
    # init a xdcr server
    exec { "couchbase-xdcr-init":
        command => "/opt/couchbase/bin/couchbase-cli xdcr-setup \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --create \
            --xdcr-cluster-name=elasticsearch \
            --xdcr-hostname=es01.example.com:9091 \
            --xdcr-username=Administrator \
            --xdcr-password=Couchbase@dm1n",
    }->

    #xdcr-replication-mode=capi is important: version2 protocal is not allowed
    exec { "couchbase-xdcr-audittrail":
        path => ['/usr/bin:/bin'],
        command => "sleep 20 && /opt/couchbase/bin/couchbase-cli xdcr-replicate \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --create \
            --xdcr-cluster-name=elasticsearch \
            --xdcr-from-bucket=audittrail \
            --xdcr-to-bucket=audittrail \
            --xdcr-replication-mode=capi",
        logoutput => on_failure,
    }->

    # Adding node to cluster and rebalance
    exec { "add-node-cluster":
        path => ['/usr/bin:/bin'],
        command => "sleep 20 && /opt/couchbase/bin/couchbase-cli rebalance \
            -c localhost:8091 \
            -u Administrator \
            -p Couchbase@dm1n \
            --server-add=22.22.22.22:8091 \
            --server-add-username=Administrator \
            --server-add-password=Couchbase@dm1n",
    }
}
