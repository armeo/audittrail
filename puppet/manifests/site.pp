Package {
	allow_virtual => true,
}

# create a new run stage to ensure certain modules are included first
stage { 'pre':
  before => Stage['main']
}

# add the bootstrap module to the new 'pre' run stage
class { 'bootstrap':
  stage => 'pre'
}

# set defaults for file ownership/permissions
File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

# all boxes get the bootstrap
include bootstrap

node 'cb01' {
  include couchbase
}

node 'cb02' {
  include couchbase
  include xdcr
}

node 'es01' {
  include elasticsearch
}
