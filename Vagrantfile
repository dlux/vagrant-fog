# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.require_version ">= 1.8.4"

Vagrant.configure(2) do |config|

  config.vm.box_check_update = false
  config.vm.hostname = 'fog'
  config.vm.network :forwarded_port, guest: 80, host: 8090
  config.vm.box = 'centos/7'
  config.vm.provision 'shell' do |s|
    s.path = 'fog_setup.sh'
    s.args = ENV['http_proxy']
  end

  config.vm.provider 'virtualbox' do |v|
    v.customize ["modifyvm", :id, "--natnet1", "192.168.0.0/27"]
    v.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
    v.customize ["modifyvm", :id, "--cpus", 1]
  end

end
