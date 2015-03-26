# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$instances = (ENV['INSTANCES'] || 2).to_i

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  $instances.times do |n|
    id = n+1
    ip = "10.20.3.1#{id}"
    name = "swarm-#{id}"

    config.vm.define name do |instance|
      instance.vm.hostname = name
      instance.vm.box = "ubuntu/trusty64"
      instance.vm.provision :shell, :path => 'scripts/puppet.sh'
      instance.vm.provision :hosts
      instance.vm.provision :puppet do |puppet|
        puppet.options        = '--debug --verbose --summarize --reports store --hiera_config=/vagrant/hiera.yaml'
        puppet.manifests_path = 'manifests'
        puppet.module_path    = [ 'modules', 'vendor/modules' ]
        puppet.manifest_file  = 'base.pp'
      end
      instance.vm.network "private_network", :ip => ip
    end
  end

end
