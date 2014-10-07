echo "Adding puppet repo"
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

echo "installing puppet"
sudo yum -y install puppet

echo "ensure puppet service is running"
sudo puppet resource service puppet ensure=running enable=true

echo "ensure puppet service is running for standalone install"
sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/usr/bin/puppet apply $(puppet apply --configprint manifest)'


echo "packages is up to date"
sudo yum -y update

echo "install packages for elasticsearch and couchbase"
sudo yum -y install wget curl unzip pkgconfig openssl098e java-1.7.0-openjdk