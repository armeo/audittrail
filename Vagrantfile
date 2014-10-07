# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'test.com'
box = 'centos65-puppet'
#box = 'chef/centos-6.5'

nodes = [
	{ :hostname => 'es01', :ip => '11.11.11.11', :box => box },
	{ :hostname => 'cb01', :ip => '22.22.22.22', :box => box, :ram => '2048' },
	{ :hostname => 'cb02', :ip => '33.33.33.33', :box => box, :ram => '2048' },
]

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    #config.vm.provision "shell", path: "shell/puppet.sh"

	nodes.each do |node|
		config.vm.define node[:hostname] do |node_config|
			node_config.vm.box = node[:box]
			node_config.vm.host_name = node[:hostname] + '.' + domain
			node_config.vm.network "private_network", ip: node[:ip]
			memory = node[:ram] ? node[:ram] : 1024;

            node_config.vm.provider :virtualbox do |v|
                v.name = node[:hostname]
                v.customize ["modifyvm", :id, "--memory", memory.to_s]
                v.customize ["modifyvm", :id, "--cpus", "2"]
            end
		end
	end

	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = 'puppet/manifests'
		puppet.manifest_file = 'site.pp'
		puppet.module_path = 'puppet/modules'
	end
end
