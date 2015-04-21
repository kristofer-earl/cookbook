Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, host: 5000, guest: 80

  config.vm.provider :virtualbox do |vb|
    # set to true if you need to see a "physical" console in a VirtualBox window
    vb.gui = false

    # add more ram (in MB), default is 1GB (1024MB)
    vb.customize ["modifyvm", :id, "--memory", "1536"]

    # uncomment the following two lines if you plan to use 2 (or more cores)
    #vb.customize ["modifyvm", :id, "--ioapic", "on"]
    #vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "hhvm"
    chef.cookbooks_path = "./"

    #chef.json = {
    #  'hhvm3' => {
    #    '' => "-Xmx1024m -Xms512m -XX:MaxPermSize=128m"
    #  }
    #}
  end
end

