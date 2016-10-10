Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define :vm02 do |vm02|
    vm02.vm.hostname = "vm02"
    vm02.vm.network :private_network, ip: "192.168.33.11"
    vm02.vm.provision "shell", :path => "provision.sh", :args => "client", :privileged => true
  end

  config.vm.define :vm01 do |vm01|
    vm01.vm.hostname = "vm01"
    vm01.vm.network :private_network, ip: "192.168.33.10"
    vm01.vm.provision "shell", :path => "provision.sh", :args => "server", :privileged => true
  end

end
